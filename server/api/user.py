__author__ = 'johnson'

from flask import Blueprint
from api.base import mobile_request

user_api = Blueprint('user', __name__)


@mobile_request
@user_api.route('/add_user', methods=['POST'])
def add_user(email, name, password):
    return email
