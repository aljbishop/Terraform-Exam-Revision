terraform {
  backend "s3" {
    bucket = "terraform-backend-1995"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "force-unlock-terraform"
  }
}


provider "aws" {
  region = "us-east-1"
#     assume_role = {
#     role_arn = "${var.workspace_iam_roles[terraform.workspace]}"
#   }
 }

module "module-apache" {
  source  = "abishop-Insight/module-apache/aws"
  version = "1.0.0"
  vpc_id          = var.vpc_id
  my_ip_with_cidr = var.my_ip_with_cidr
  public_key      = var.public_key
  instance_type   = var.instance_type
  server_name     = var.server_name
}

output "public_ip" {
  value = module.module-apache.public_ip
}