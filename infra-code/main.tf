module "vpc" {
  source            = "./aws-modules/aws-vpc"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.0.0/24"
  availability_zone = "${var.region}b"
  additional_tags = {
    "Application" = "flaskapp"
    "Name"        = "Flask-app-server"
    "Type"        = "vpc"
  }
}

module "server" {
  source               = "./aws-modules/aws-instance"
  ami                  = "ami-083654bd07b5da81d"
  availability_zone    = "${var.region}b"
  instance_type        = "c4.xlarge"
  key_name             = "siva"
  subnet_id            = module.vpc.subnet_id
  vpc_id               = module.vpc.vpc_id
  security_group_name  = "flask-app-server-security-group"
  user_data            = local.user_data
  additional_tags = {
    "Application" = "flaskapp"
    "Name"        = "Flask-app-server"
    "Type"        = "Instance"
  }
  ingress_rule = {
    "22" = ["0.0.0.0/0"]
    "80"   = ["0.0.0.0/0"]
  }
}
    
