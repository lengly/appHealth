from flask import Blueprint
from google.appengine.ext import blobstore
from api.base import mobile_request, require_login
from entity.moment import Moment
from datetime import datetime
from module.errors import *
__author__ = 'johnson'

moment_api = Blueprint('moment', __name__)


@moment_api.route('/moment/me', methods=['POST'])
@mobile_request
@require_login
def get_my_moment(user_id, time_stamp):
    # TODO get moments of all friends
    pass


@moment_api.route('moment/all', methods=['POST'])
@mobile_request
@require_login
def get_all_moment(user_id, time_stamp):
    pass


@moment_api.route('/moment/create', methods=['POST'])
@mobile_request
@require_login
def create_moment(user_id, text=None, pic_id=None, source_id=None):
    if not text and not pic_id and not source_id:
        raise NoContentException()
    now = datetime.now()
    moment = Moment(user_id=user_id, time_created=now, time_modified=now)
    if source_id:
        source_id = int(source_id)
        source_moment = Moment.get_by_id(source_id)
        moment.populate(source_key=(source_moment.source_key if source_moment.source_key else source_moment.key))
    else:
        moment.populate(text=text, pic=blobstore.get(pic_id).key())
    moment.put()
    return {
        'moment_id': moment.key.id(),
        'user_id': moment.user_id,
        'source_key': moment.source_key.id() if moment.source_key else None,
        'text': moment.text,
        'pic': moment.pic.ToXml() if moment.pic else None,
        'time_created': moment.time_created
    }


@moment_api.route('/moment/update', methods=['POST'])
@mobile_request
@require_login
def update_moment(user_id, moment_id, text=None, pic=None):
    moment_id = int(moment_id)
    moment = Moment.get_by_id(moment_id)
    if not moment:
        raise MomentNotFoundException(moment_id)
    if not moment.user_id == user_id:
        raise UnauthorizedOperationException('attempted to update non self moment')
    if text:
        moment.text = text
    if pic:
        moment.pic = blobstore.get(pic).key()
    now = datetime.now()
    moment.time_modified = now
    moment.put()
    return {
        'moment_id': moment.key.id(),
        'user_id': moment.user_id,
        'text': moment.text,
        'pic': moment.pic.ToXml() if moment.pic else None
    }


@moment_api.route('/moment/delete', methods=['POST'])
@mobile_request
@require_login
def delete_moment(user_id, moment_id):
    moment_id = int(moment_id)
    moment = Moment.get_by_id(moment_id)
    if not moment.user_id == user_id:
        raise UnauthorizedOperationException('attempted to update non self moment')
    now = datetime.now()

    moment.time_modified = now
    moment.time_removed = now
    moment.put()
    return {
        'moment_id': moment.key.id(),
        'time_removed': moment.time_removed
    }
