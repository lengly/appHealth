from google.appengine.ext import ndb
__author__ = 'johnson'


class Token(ndb.Model):
    user_id = ndb.IntegerProperty()
    token = ndb.StringProperty()
