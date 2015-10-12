from flask import Blueprint
from api.base import mobile_request, require_login
from entity.user import User
from entity.token import Token
from entity.profile import Profile
from entity.relation import Relation
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
def get_profile(user_id):
    if not module_user.get_user_by_id(user_id):
        raise UserNotFoundException(user_id)
    profile = Profile.get_by_id(user_id)
    return {
        'user_id': user_id,
        'nick_name': profile.nick_name if profile else None,
        'birthday': profile.birthday.strftime(DATE_FORMAT) if profile and profile.birthday else None,
        'gender': profile.gender if profile else None,
        'head_pic': profile.head_pic if profile else None
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


@user_api.route('/friend/')
@mobile_request
@require_login
def get_friends(user_id):
    pass


@user_api.route('/friend/followers')
@mobile_request
@require_login
def get_followers(user_id):
    pass


@user_api.route('/friend/follow', methods=['POST'])
@mobile_request
@require_login
def follow(user_id, friend_id):
    friend_id = int(friend_id)
    friend = User.get_by_id(friend_id)
    if not friend:
        raise UserNotFoundException(friend_id)

    relation_key = ndb.Key(Relation, user_id)
    relation = Relation(key=relation_key, user_id=user_id)
    if friend.key not in relation.follows_key:
        relation.follows_key.append(friend.key)
    relation.put()

    friend_relation_key = ndb.Key(Relation, friend_id)
    friend_relation = Relation(key=friend_relation_key, user_id=friend_id)
    if ndb.Key(User, user_id) not in friend_relation.followers_key:
        friend_relation.followers_key.append(ndb.Key(User, user_id))
    friend_relation.put()
    return {
        'user_id': relation.user_id,
        'follows': list({v.id() for v in relation.follows_key}) if relation.follows_key else None,
        'followers': list({v.id() for v in relation.followers_key}) if relation.followers_key else None
    }


@user_api.route('/friend/unfollow', methods=['POST'])
@mobile_request
@require_login
def unfollow(user_id, friend_id):
    friend_id = int(friend_id)
    friend = User.get_by_id(friend_id)
    if not friend:
        raise UserNotFoundException(friend_id)

    relation_key = ndb.Key(Relation, user_id)
    relation = Relation(key=relation_key, user_id=user_id)
    if friend.key in relation.follows_key:
        relation.follows_key.remove(friend.key)
    relation.put()

    friend_relation_key = ndb.Key(Relation, friend_id)
    friend_relation = Relation(key=friend_relation_key, user_id=friend_id)
    if ndb.Key(User, user_id) in friend_relation.followers_key:
        friend_relation.followers_key.remove(ndb.Key(User, user_id))
    friend_relation.put()
    return {
        'user_id': relation.user_id,
        'follows': list({v.id() for v in relation.follows_key}) if relation.follows_key else None,
        'followers': list({v.id() for v in relation.followers_key}) if relation.followers_key else None
    }


@user_api.route('/authenticate')
@mobile_request
@require_login
def authenticate(user_id):
    return 'authentication passed: ' + str(user_id)
