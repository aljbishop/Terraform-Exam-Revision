terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "terraform-training-ab"

    workspaces {
      name = "terraform-example"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }
}
  
