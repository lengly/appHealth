from flask import Blueprint
from api.base import mobile_request, require_login
from entity.user import User
from entity.token import Token
from module.errors import *
from google.appengine.ext import ndb
import module.user as module_user
__author__ = 'johnson'

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


@user_api.route('/authenticate')
@mobile_request
@require_login
def authenticate(user_id):
    return 'authentication passed: ' + str(user_id)
