#### flask-application

In this application developed by python flask framework.

`Application development Requirements`

    1. python3 
    2. pip3 
    3. code editor
    4. linux server or docker 

`development folder structure is`

<!-- ![image](https://user-images.githubusercontent.com/57703276/143470477-39a04c44-89d4-4019-ba22-bfb0831e889f.png) -->

```bash

flask-application
|-- app.py
|-- requirments.txt
|-- static
    |-- css
        |-- style.css
|-- templates
    |-- base.html
    |-- index.html
|-- Dockerfile
|-- Readme.md
```

`Flask`

```bash
It makes the process of designing a web application simpler. 
Flask lets us focus on what the users are requesting and what sort of response to give back.
```
1. `app.py`

app.py contains the application’s code, where you create the app and its views.

```python

# entrypoint of the application
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

```
2. `requirements.txt`

```bash

flask
requests

```


3. `static`

```css

# static/css/style.css
h1 {
    border: 2px #eee solid;
    color: brown;
    text-align: center;
    padding: 10px;
}

```


4. `templates`

```html

# base.html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <title>quotes</title>
  </head>
  <body>
    <nav class="navbar navbar-expand-md navbar-light bg-light">
        <a class="navbar-brand" href="{{ url_for('index')}}">QUOTES</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
    </nav>
    <div class="container">
        {% block content %} {% endblock %}
    </div>
  </body>
</html>

```

```html
# index.html
{% extends 'base.html' %}
    {% block content %}
            {% block title %}
            <pre>
                <div style="background-color: #f8f9fa!important;">
                    {
                            "icon_url" : "<span id="response_icon_url">{{quotes.icon_url}}</span>",
                            "id" : "<span id="response_id">{{quotes.id}}</span>",
                            "url" : "<a id="response_url">{{quotes.url}}</a>",
                            "value" : "<span id="response_text">{{quotes.value}}</span>"
                            "created_at" : "<span id="response_text">{{quotes.created_at}}</span>"
                            "updated_at" : "<span id="response_text">{{quotes.updated_at}}</span>"
                    }
                </div>
            </pre>
        {% endblock %}
{% endblock %}
```


5. `Dockerfile`

```Dockerfile
# referece image from alpine family
FROM alpine
# Upgrade the packages to avoid the vulnarability
RUN apk upgrade 
# Python3 installation
RUN apk add python3
# Pip3 installtion
RUN apk add py3-pip
# Setup the working directory
WORKDIR /usr/app
# Create the user and group to avoid the root privileges 
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# Copy the dependencies files
COPY requirments.txt .
# To setup the user and group privileges from the application directory
RUN chown -R appuser:appgroup /usr/app
# swutch the user mode
USER appuser
# install the dependencies packages
RUN pip3 install -r requirments.txt
# copy the dependencies files
COPY . .
# Run the process
CMD ["python3", "app.py"]
```

CICD preparation steps

`dependencies`
    
    1. docker username
    2. docker password/token
    
```yml
---
name: flask app build and deployment
on: [push]
jobs:
  dev:
    name: Flask app deployment
    runs-on: ubuntu-latest
    steps:
      - name: checkout
        uses: actions/checkout@v1
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1
      - name: docker login
        run: |
          echo ${{ secrets.DOCKER_TOKEN }} | docker login --username ${{ secrets.DOCKER_USER }} --password-stdin
      - name: docker build 
        run: |
          docker build -t  ${{ secrets.DOCKER_USER }}/flaskapi:$GITHUB_RUN_ID .
      - name: show the docker image name
        run: |
          echo ${{ secrets.DOCKER_USER }}/flaskapi:$GITHUB_RUN_ID
      - name: docker push 
        run: |
          docker push ${{ secrets.DOCKER_USER }}/flaskapi:$GITHUB_RUN_ID
      - name: docker logout
        run: |
          docker logout
```




`output`

![image](https://user-images.githubusercontent.com/57703276/143309870-a43a000c-9333-416f-af96-e400feb0a1a5.png)
