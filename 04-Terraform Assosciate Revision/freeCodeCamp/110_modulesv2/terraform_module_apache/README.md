Terraform module which creates an Apache EC2 INSTANCE resource on AWS.

Just a test module to practice for the Terraform Associate exam.

```hcl
terraform {
}

provider "aws" {
  region = "us-east-1"
}

module "apache" {
  source          = ".//terraform_module_apache"
  vpc_id          = "vpc-00000000"
  my_ip_with_cidr = "MY_OWN_IP_ADDRESS/32"
  public_key      = "ssh-rsa AAAAB..."
  instance_type   = "t2.micro"
  server_name     = "Apache-Server"
}

output "public_ip" {
  value = module.apache.public_ip
}
```