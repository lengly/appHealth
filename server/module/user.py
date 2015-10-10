import uuid
from google.appengine.ext import ndb
from entity.user import User
from entity.token import Token
__author__ = 'johnson'


def is_token_valid(ut):
    qry = Token.query(getattr(Token, 'token') == ut)
    tokens = qry.fetch(1)
    if not tokens:
        return False, -1
    return True, tokens[0].user_id


def get_user_by_id(user_id):
    return ndb.Key(User, user_id).get()
    pass


def generate_token(user_id):
    random = uuid.uuid4().hex
    return random + hex(user_id)[2:-1]
