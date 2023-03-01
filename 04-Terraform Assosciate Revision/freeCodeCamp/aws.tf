resource "aws_instance" "alex_server1" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = var.instance_type
    provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }

  tags = {
    Name = "alexServer101"
  }
}

