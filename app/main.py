import os

from flask import Flask

app = Flask(__name__)


@app.route('/', methods=['GET'])
def hello_world():
    return 'Hello World!'


if __name__ == '__main__':
    port = os.getenv("PORT", 8080)
    host_address = os.getenv("HOST", '0.0.0.0')
    if os.getenv("DEBUG", False):
        is_debug = True
    else:
        is_debug = False

    app.run(debug=is_debug, host=host_address, port=port)
