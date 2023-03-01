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
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"


  tags = {
    Name = "Server"
  }
  lifecycle {
    prevent_destroy = false
  }
}


output "public_ip" {
  value = aws_instance.alex_server[*].public_ip
}
