from google.appengine.ext import ndb
__author__ = 'johnson'


class Profile(ndb.Model):
    GENDER_MALE = 'male'
    GENDER_FEMALE = 'female'
    GENDER_SECRETE = 'secrete'

    nick_name = ndb.StringProperty()
    birthday = ndb.DateProperty()
    gender = ndb.StringProperty()
    head_pic = ndb.StringProperty()
