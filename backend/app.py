from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)

# Since the API is running on port 5000, we need to explicitly allow the frontend to access it from port 3000
CORS(app, resources={r"/api/*": {"origins": "http://localhost:3000"}})

@app.route('/api/hello', methods=['GET'])
def hello():
    """
    It ain't much, but it's honest work.
    """
    return jsonify({"message": "Hello, World!"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
