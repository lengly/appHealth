from flask import Blueprint
from api.base import mobile_request, require_login
from entity.user import User
from entity.token import Token
from entity.profile import Profile
from module.errors import *
from google.appengine.ext import ndb
from datetime import datetime
import module.user as module_user
__author__ = 'johnson'

DATE_FORMAT = '%Y-%m-%d'
user_api = Blueprint('user', __name__)


@user_api.route('/sign_up', methods=['POST'])
@mobile_request
def sign_up(email, name, password):
    qry = User.query(getattr(User, 'email') == email)
    if qry.fetch(1):
        raise UserAlreadyExistsException(email)
    new_user = User(email=email, name=name, password=password)
    new_user.put()
    print(type(new_user.email))
    return email


@user_api.route('/sign_in', methods=['POST'])
@mobile_request
def sign_in(email, password):
    qry = User.query(ndb.AND(getattr(User, 'email') == email, getattr(User, 'password') == password))
    users = qry.fetch(1)
    if not users:
        raise LoginFailedException()
    user = users[0]
    token_val = module_user.generate_token(user.key.id())
    token_key = ndb.Key(Token, user.key.id())
    token = Token(key=token_key)
    token.populate(user_id=user.key.id(), token=token_val)
    token.put()
    return {
        'user_id': token.user_id,
        'token': token.token
    }


@user_api.route('/profile')
@mobile_request
@require_login
def get_profile(user_id):
    profile = Profile.get_by_id(user_id)
    print profile
    return {
        'user_id': user_id,
        'nick_name': profile.nick_name,
        'birthday': profile.birthday.strftime(DATE_FORMAT) if profile.birthday else None,
        'gender': profile.gender,
        'head_pic': profile.head_pic
    }


@user_api.route('/profile/edit', methods=['POST'])
@mobile_request
@require_login
def edit_profile(user_id, nick_name=None, birthday=None, gender=None, head_pic=None, password=None):
    user = module_user.get_user_by_id(user_id)
    if password:
        user.password = password
        user.put()
    profile_key = ndb.Key(Profile, user.key.id())
    profile = Profile(key=profile_key)
    if nick_name:
        profile.nick_name = nick_name
    if birthday:
        profile.birthday = datetime.strptime(birthday, DATE_FORMAT)
    if gender:
        profile.gender = gender
    if head_pic:
        profile.head_pic = head_pic
    profile.put()
    return {
        'user_id': user.key.id(),
        'nick_name': profile.nick_name,
        'birthday': profile.birthday.strftime(DATE_FORMAT) if profile.birthday else None,
        'gender': profile.gender,
        'head_pic': profile.head_pic
    }


@user_api.route('/authenticate')
@mobile_request
@require_login
def authenticate(user_id):
    return 'authentication passed: ' + str(user_id)
