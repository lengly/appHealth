import json
import functools
from flask import request, jsonify
from flask.wrappers import Response
import module.user as module_user
from module.errors import *
__author__ = 'johnson'

RESPONSE_CODE_SUCCESS = 200
RESPONSE_CODE_FAIL = 400


def _build_deco_chain(decoding_func, decoded_func, decoding_obj):
    if not hasattr(decoded_func, '_real_func'):
        decoded_func._real_func = decoded_func
    _real_func = decoded_func._real_func
    decoding_func._real_func = _real_func
    setattr(_real_func, '_decorators', getattr(_real_func, '_decorators', []) + [decoding_obj])


def handle_mobile_request(func, *args, **kwargs):
    kwargs = kwargs.copy()
    if request.args:
        kwargs.update(request.args.to_dict())
    if request.data:
        data = json.loads(request.data)
        # to support escape character in json value
        data = {k: (lambda x: x.replace('\\n', '\n'))(v) for k, v in data.items()}
        print data['text']
        kwargs.update(data)
    if request.form:
        kwargs.update(request.form.to_dict())
    if request.files:
        kwargs.update({k: request.files.getlist(k) for k in request.files})
    if request.headers.get('Authorization'):
        try:
            ut = request.headers.get('Authorization')
            valid, user_id = module_user.is_token_valid(ut)
            user = module_user.get_user_by_id(user_id) if user_id else None
            if not user:
                raise UserNotFoundException()
            kwargs['user_id'] = user_id
        except:
            raise UserNotFoundException()
    if hasattr(func, '_real_func') and getattr(func._real_func, '_login_required', False) and 'user_id' not in kwargs:
        raise NeedLoginException()
    print request, kwargs
    return func(*args, **kwargs)


def mobile_request(func):
    @functools.wraps(func)
    def wrapped(*args, **kwargs):
        resp = {'rc': RESPONSE_CODE_SUCCESS, 'content': ''}
        try:
            data = handle_mobile_request(func, *args, **kwargs)
            if isinstance(data, Response):
                return data
            elif isinstance(data, dict) or isinstance(data, (str, unicode)):
                resp['content'] = data
            elif isinstance(data, (int, long, float, bool)):
                resp['content'] = str(data)
            else:
                raise UnknownControllerReturnType(str(type(data)))
        except Exception as e:
            resp['rc'] = RESPONSE_CODE_FAIL
            resp['content'] = type(e).__name__ + ' ' + e.message
        return jsonify(resp)
    _build_deco_chain(wrapped, func, mobile_request)
    return wrapped


def require_login(func):
    @functools.wraps(func)
    def wrapped(*args, **kwargs):
        return func(*args, **kwargs)
    _build_deco_chain(wrapped, func, require_login)
    wrapped._real_func._login_required = True
    return wrapped
