provider "aws" {
  region = "us-east-1"
}
data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket  = "dev/tfstate.tfstate"
        key     = "dev/tfstate.tfstate"
        region  = "eu-central-1"
    }
}