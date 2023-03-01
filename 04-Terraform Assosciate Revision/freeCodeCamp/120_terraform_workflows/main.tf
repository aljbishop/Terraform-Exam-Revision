terraform {
  cloud {
    organization = "Terraform-Exam-Prep-01"
    hostname = "app.terraform.io"

    workspaces {
      name = "vcs-terraform"
    }
  }
}





provider "aws" {
  region = "us-east-1"
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
