data "aws_vpc" "default_vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.default_vpc.id
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
    cidr_blocks = [var.my_ip_with_cidr]
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
  public_key = var.public_key
}


data "template_file" "user_data" {
  template = file("${abspath(path.module)}/userdata.yaml")
}


data "aws_ami" "amazon-linux-2" {
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



resource "aws_instance" "alex_server1" {
  ami                    = "${data.aws_ami.amazon-linux-2.id}"
  subnet_id              = tolist(data.aws_subnet_ids.subnet_ids.ids)[0]
  instance_type          = var.instance_type
  key_name               = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.sg_alex_server.id]
  user_data              = data.template_file.user_data.rendered

  tags = {
    Name = var.server_name
  }
}