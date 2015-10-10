__author__ = 'johnson'


class UserNotFoundException(Exception):
    pass


class NeedLoginException(Exception):
    pass


class UnknownControllerReturnType(Exception):
    pass


class UserAlreadyExistsException(Exception):
    pass


class LoginFailedException(Exception):
    pass
