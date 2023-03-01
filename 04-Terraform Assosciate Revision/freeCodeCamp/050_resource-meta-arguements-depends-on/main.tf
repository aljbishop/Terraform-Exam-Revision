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


resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-depends-on1"

}




resource "aws_instance" "alex_server1" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  depends_on = [
    aws_s3_bucket.bucket
  ]


  tags = {
    Name = "alexServer301"
  }
}


output "public_ip" {
  value = aws_instance.alex_server1.public_ip
}
