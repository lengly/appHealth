from flask import Flask
from api.ping import ping_api
from api.user import user_api
from api.mock import mock_api
from api.upload import upload_api
from api.download import download_api
__author__ = 'johnson'

app = Flask(__name__)
app.register_blueprint(ping_api)
app.register_blueprint(user_api)
app.register_blueprint(mock_api)
app.register_blueprint(upload_api)
app.register_blueprint(download_api)


if __name__ == '__main__':
    app.run()
