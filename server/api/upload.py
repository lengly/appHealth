from flask import Blueprint
from api.base import mobile_request, require_login
from google.appengine.ext import blobstore
__author__ = 'johnson'

upload_api = Blueprint('upload', __name__)
UPLOAD_IMAGE_URL = '/upload_image'


@upload_api.route('/upload/get_url')
@mobile_request
@require_login
def get_url(user_id):
    upload_url = blobstore.create_upload_url(UPLOAD_IMAGE_URL)
    return upload_url


@upload_api.route(UPLOAD_IMAGE_URL, methods=['POST'])
@mobile_request
def upload_image(pic_file, user_id=None):
    if isinstance(pic_file, list):
        pic_file = pic_file[0]
    headers = pic_file.headers
    content_type = headers['Content-Type']
    blob_key = filter(lambda x: x.startswith('blob-key'), content_type.split('; '))[0][10:-1]
    return {'blob_key': blob_key}
