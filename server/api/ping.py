from flask import Blueprint
__author__ = 'johnson'

ping_api = Blueprint('ping', __name__)


@ping_api.route('/ping')
def ping():
    return 'pang'
