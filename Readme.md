`Deutsche Boerse - Home evaluation for DevOps Engineer role1`
======================================

# Objective: 
    `Python application has been created using flask framework to render the interesting Chuck Norris jokes from API https://api.chucknorris.io/ and display through webpage . 
     Infrastructure has to be created using IAC.` 
     

This task has been divided into two parts 
  1. Infra Code
  2. Application Code

    1.`Infrastructure has been created using IAC - Terraform` . 
    2.`Python application has been created using Flask framework` 


# 1. Infra Setup - Overview

#### Flask-application infra provision

In this application developed by python flask framework.

`terraform development Requirements`

    1. terraform 
    2. aws credentials 
    3. code editor
    4. linux server
    5. s3 bucket 

`IaC folder structure`

```bash

infra-code
|-- aws-modules
|   |-- aws-instance
|       |-- main.tf
|       |-- output.tf
|       |-- variable.tf
|   |-- aws-vpc
|       |-- main.tf
|       |-- output.tf
|       |-- variable.tf
|-- backend.tf
|-- main.tf
|-- locals.tf
|-- provider.tf
|-- config.tfvars

```

`Terraform`

```bash

Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services.

```

`Provider`

    1. Each provider adds a set of resource types and/or data sources that Terraform can manage.
    2. Every resource type is implemented by a provider; without providers, Terraform can't manage any kind of infrastructure.
    3. Most providers configure a specific infrastructure platform (either cloud or self-hosted). Providers can also offer local utilities for tasks like generating random numbers for unique resource names.

`Module`

    1. Modules are the main way to package and reuse resource configurations with Terraform.
    2. Modules are containers for multiple resources that are used together. A module consists of a collection of .tf and/or .tf.json files kept together in a directory.

`Backend`

    1. Each Terraform configuration can specify a backend, which defines where and how operations are performed, where state snapshots are stored, etc.
    2. There are two areas of Terraform's behavior that are determined by the backend:
        2.1. Where state is stored.
        2.2. Where operations are performed.
    3. State
        Terraform uses persistent state data to keep track of the resources it manages. Since it needs the state in order to know which real-world infrastructure objects correspond to the resources in a configuration, everyone working with a given collection of infrastructure resources must be able to access the same state data.

`manual commands`

```bash
  export AWS_ACCESS_KEY_ID="aka"
  export AWS_SECRET_ACCESS_KEY="aka"
  export AWS_DEFAULT_REGION="aka"
  terraform init \
      -backend-config="bucket=aks" \
      -backend-config="key=dev/tfstate.tfstate" \
      -backend-config="region=aka" \
      -backend=true
  terraform validate
  terraform plan -var-file=config.tfvars
  terraform apply -var-file=config.tfvars
```

`GitHub Action`

    A workflow is a configurable automated process made up of one or more jobs. You must create a YAML file to define your workflow configuration

`when action is trigger`

    In this case, we want to run when anything in the infra-code directory is changed in the main branch. We can use a wildcard as part of our path filter


```yaml
---
name: infra provisioning
on:
  push:
    branches:
    - main
    paths:
    - 'infra-code/**'
jobs:
  dev:
    name: terraform deployment
    runs-on: ubuntu-latest
    env:
      bucket: terraform-backend-buckets
    strategy:
      matrix:
        folder: ['infra-code']
    defaults:
      run:
        shell: bash
        working-directory: ${{ matrix.folder }}
    steps:
      - name: checkout
        uses: actions/checkout@v1
      - name: setup terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 0.14.6
      - name: configure aws credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.ACCESS_KEY }}
          aws-secret-access-key: ${{ secrets.SECRET_KEY }}
          aws-region: us-east-1
      - name: initial
        run: |
          terraform init \
            -backend-config="bucket=${{ env.bucket }}" \
            -backend-config="key=dev/tfstate.tfstate" \
            -backend-config="region=eu-central-1" \
            -backend=true
      - name: validate
        run: terraform validate
      - name: plan
        run: terraform  plan -var-file=config.tfvars
      - name: apply
        run: terraform  apply -var-file=config.tfvars -auto-approve
      - name: terraform destroy
        run: terraform  destroy -var-file=config.tfvars -auto-approve

```

`output`

It will create the aws resources
    
    1. vpc
    2. subnet
    3. route table
    4. internet gateway
    5. security group
    6. instance
    
# 2. Python Application Setup 


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
