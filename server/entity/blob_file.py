from google.appengine.ext import ndb
__author__ = 'johnson'


class BlobFile(ndb.Model):
    blob_key = ndb.BlobKeyProperty()
    file_name = ndb.StringProperty()
