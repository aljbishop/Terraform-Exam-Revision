terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }
}


variable "instance_type" {
  type        = string
  description = "The size of the instance."
  # sensitive = true
  validation {
    condition     = can(regex("^t2.", var.instance_type))
    error_message = "The instance must be a t3 type EC2 instance."
  }
}


provider "aws" {
  region = "us-east-1"
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "alex_server1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }

  tags = {
    Name = "alexServer201"
  }
}

output "public_ip" {
  value = aws_instance.alex_server1.public_ip
  # sensitive = true
}
