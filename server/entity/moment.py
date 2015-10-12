from google.appengine.ext import ndb
__author__ = 'johnson'


class Moment(ndb.Model):
    user_id = ndb.IntegerProperty()
    text = ndb.StringProperty()
    pic = ndb.BlobKeyProperty()
    source_key = ndb.KeyProperty()
    time_created = ndb.DateTimeProperty()
    time_modified = ndb.DateTimeProperty()
    time_removed = ndb.DateTimeProperty()
