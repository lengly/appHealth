from google.appengine.ext import ndb
__author__ = 'johnson'


class Comment(ndb.Model):
    text = ndb.StringProperty()
    moment_key = ndb.KeyProperty()
    user_id = ndb.IntegerProperty()
    commented_key = ndb.KeyProperty()
    comments_key = ndb.KeyProperty(repeated=True)
