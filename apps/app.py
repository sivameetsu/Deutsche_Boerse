from flask import Flask, render_template
import requests

app = Flask(__name__)

api="https://api.chucknorris.io/jokes/random"

@app.route('/')
def index():
    response = requests.get(api)
    return render_template ("index.html", quotes=response.json())

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
