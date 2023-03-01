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
  #alias  = "east"
}

provider "aws" {
  region = "us-west-1"
  alias  = "west"
}

data "aws_ami" "east-amazon-linux-2" {
  #provider    = aws.east
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_ami" "west-amazon-linux-2" {
  provider    = aws.west
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_instance" "alex_server" {
  for_each = {
    nano  = "t2.nano"
    micro = "t2.micro"
  }
  ami           = data.aws_ami.east-amazon-linux-2.id
  instance_type = each.value
  #provider      = aws.east


  tags = {
    Name = "East-Server-${each.key}"
  }
}

resource "aws_instance" "alex_server2" {
  count         = 3
  ami           = data.aws_ami.west-amazon-linux-2.id
  instance_type = "t2.medium"
  provider      = aws.west


  tags = {
    Name = "West-Server-${count.index}"
  }
}


output "east-public_ip" {
  value = values(aws_instance.alex_server)[*].public_ip
}

output "west-public_ip" {
  value = aws_instance.alex_server2[*].public_ip
}
