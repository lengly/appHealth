import module.constant as constant
from flask import Blueprint
from google.appengine.ext import ndb, blobstore
from api.base import mobile_request, require_login
from entity.moment import Moment
from entity.relation import Relation
from datetime import datetime
from module.momend import transform as moment_transform
from module.errors import *
__author__ = 'johnson'

moment_api = Blueprint('moment', __name__)


@moment_api.route('/moment/my', methods=['POST'])
@mobile_request
@require_login
def get_my_moment(user_id, time_stamp):
    time_stamp = datetime.strptime(time_stamp, constant.DATE_TIME_FORMAT)
    qry = Moment.query(ndb.AND(getattr(Moment, 'user_id') == user_id, getattr(Moment, 'time_modified') >= time_stamp))
    moments = qry.fetch()
    moment_list = map(moment_transform, moments)
    print moment_list
    return {'moments': moment_list}


@moment_api.route('/moment/all', methods=['POST'])
@mobile_request
@require_login
def get_all_moment(user_id, time_stamp):
    user_id = int(user_id)
    time_stamp = datetime.strptime(time_stamp, constant.DATE_TIME_FORMAT)
    relation_key = ndb.Key(Relation, user_id)
    relation = Relation(key=relation_key)
    friends_key = relation.follows_key
    moment_list = []
    for friend_key in friends_key:
        qry = Moment.query(ndb.AND(getattr(Moment, 'user_id') == friend_key.id, getattr(Moment, 'time_modified') >= time_stamp))
        moments = qry.fetch()
        moment_list.append(map(moment_transform, moments))
    qry = Moment.query(ndb.AND(getattr(Moment, 'user_id') == user_id, getattr(Moment, 'time_modified') >= time_stamp))
    moments = qry.fetch()
    moment_list.append(map(moment_transform, moments))
    return {'moments': moment_list}


@moment_api.route('/moment/create', methods=['POST'])
@mobile_request
@require_login
def create_moment(user_id, text=None, pic_id=None, source_id=None):
    if not text and not pic_id and not source_id:
        raise NoContentException()
    now = datetime.utcnow()
    moment = Moment(user_id=user_id, time_created=now, time_modified=now)
    if source_id:
        source_id = int(source_id)
        source_moment = Moment.get_by_id(source_id)
        moment.populate(source_key=(source_moment.source_key if source_moment.source_key else source_moment.key))
    else:
        moment.populate(text=text, pic=blobstore.get(pic_id).key() if pic_id else None)
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
    now = datetime.utcnow()
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
    now = datetime.utcnow()

    moment.time_modified = now
    moment.time_removed = now
    moment.put()
    return {
        'moment_id': moment.key.id(),
        'time_removed': moment.time_removed
    }
