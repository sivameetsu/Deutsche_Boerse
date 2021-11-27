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
