__author__ = 'johnson'

from flask import Blueprint

ping_api = Blueprint('ping', __name__)


@ping_api.route('/ping')
def ping():
    return 'pang'
