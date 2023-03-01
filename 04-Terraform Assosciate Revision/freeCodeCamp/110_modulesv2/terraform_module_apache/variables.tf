variable "vpc_id" {
    type = string
}

variable "my_ip_with_cidr" {
    type = string
    description = "Provide your IP e.g. 188.223.150.59/32"
    
}
variable "public_key" {
    type = string
  
}

variable "instance_type" {
    type = string
    default = "t2.mciro"
  
}

variable "server_name" {
    type = string
    default = "Apache-Server"
}