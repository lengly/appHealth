from google.appengine.ext import ndb
__author__ = 'johnson'


class Relation(ndb.Model):
    user_id = ndb.IntegerProperty()
    follows_key = ndb.KeyProperty(repeated=True)
    followers_key = ndb.KeyProperty(repeated=True)
