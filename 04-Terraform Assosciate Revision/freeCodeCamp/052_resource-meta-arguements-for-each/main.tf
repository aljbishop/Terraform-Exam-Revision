terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "alex_server" {
  for_each = {
    nano = "t2.nano"
    micro = "t2.micro"
    small = "t2.small"
  }
  ami           = "ami-0b5eea76982371e91"
  instance_type = each.value


  tags = {
    Name = "Server-${each.key}"
  }
}


output "public_ip" {
  value = values(aws_instance.alex_server)[*].public_ip
}
