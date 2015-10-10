from google.appengine.ext import ndb
__author__ = 'johnson'


class User(ndb.Model):
    name = ndb.StringProperty()
    email = ndb.StringProperty()
    password = ndb.StringProperty()
