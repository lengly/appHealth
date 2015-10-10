from flask import Blueprint
from api.base import mobile_request
__author__ = 'johnson'

mock_api = Blueprint('mock', __name__)


@mock_api.route('/mock/login', methods=['POST'])
@mobile_request
def add_user(email, name, password):
    return {'email': email, 'name': name, 'password': password}
