terraform {
  cloud {
    organization = "terraform-training-ab"

    workspaces {
      name = "force-unlocking"
    }
  }
}

provider "aws" {
    profile = "default"
    region = "us-east-1"
  
}
data "terraform_remote_state" "vpc" {
    backend = "local"
    config = {
      path = "../project1/terraform.tfstate"
     }
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