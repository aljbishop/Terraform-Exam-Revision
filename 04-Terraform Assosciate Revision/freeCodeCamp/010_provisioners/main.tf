terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.50.0"
    }
  }

    cloud {
      organization = "terraform-training-ab"

      workspaces {
        name = "provisioners"
      }
    }
}


provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default_vpc" {
  id = "vpc-0c3ec69075c28f8aa"
}


resource "aws_security_group" "sg_alex_server" {
  name        = "sg_alex_server"
  description = "Alex Server Security Group"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2FQE+nUrdrzxuQbrLWGhkHpjyOk3/T5oiVtUBfo8r1CkE5r9pNjpgRgHB1l+OzBNL+Y1LwDwQMQRqgeZ0S12/KY73zYFsVokr1RDb5i17WQGy4m6KvBv0LLeXZpap+4Cv73QF3YP2/4OcMva3jBUbmQPVlcPJArJmX1jVkIFB5Ngpj+Rb2uMpFpk8BRqOHcVrEY2ueUzI8GT+xn30gScIDgJaGyvKjqnF06vUOKyRrwZydP2IcXnlluZVBAmBAdt6Ei02CVoWxWlKIpM5d9m95cS6LNRBHD9YdR9J0mF7t9Gb7FUBVyKDV42LofupLyT6UydQNjjWGoGHmB/y5l9AVL+rMVUinFRg218VffBmXlN7oxxQtEGmo0wS0RpFmD5ZmeDMlIAcO0IdwELZAsu+6U9FCvcyDfovc+pobKOrzJgXYq+qwx7ld43OARVOOhV+b/uWRrFMSmVuqQlPCzsLVP/CotiUjGE15G+MsrahtyZnjZLP8LL3sD6gXHLNRfU= hq"
}


data "template_file" "user_data" {
  template = file("./userdata.yaml")
}


resource "aws_instance" "alex_server1" {
  ami                    = "ami-0b5eea76982371e91"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_alex_server.id]
  user_data              = data.template_file.user_data.rendered
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
  tags = {
    Name = "alexServer101"
  }

}


output "public_ip" {
  value = aws_instance.alex_server1.public_ip
}