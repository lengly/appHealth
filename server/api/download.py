from flask import Blueprint, make_response
from base import mobile_request
from google.appengine.ext import blobstore
__author__ = 'johnson'

download_api = Blueprint('download', __name__)


@download_api.route('/download')
@mobile_request
def download(blob_id):
    blob_info = blobstore.get(blob_id)
    print(blob_info)
    blob_reader = blobstore.BlobReader(blob_info)
    value = blob_reader.read()
    response = make_response(value)
    response.headers['Content-Type'] = blob_info.content_type
    response.headers['Content-Disposition'] = 'filename=%s' % blob_info.filename
    return response
