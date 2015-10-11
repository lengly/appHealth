import uuid
import module.upload as module_upload
from flask import Blueprint
from api.base import mobile_request, require_login
from google.appengine.ext import blobstore
__author__ = 'johnson'

upload_api = Blueprint('upload', __name__)
UPLOAD_IMAGE_URL = '/upload_image'


@upload_api.route('/upload/pic', methods=['POST'])
@mobile_request
@require_login
def upload_pic(user_id, pic_file):
    if isinstance(pic_file, list):
        pic_file = pic_file[0]
    header = pic_file.headers['Content-Type']

    # upload_url = blobstore.create_upload_url(UPLOAD_IMAGE_URL + "/" + str(uuid.uuid4()))

    return user_id
