locals {
  ingress = [{
  port = 443
  description = "Port 443"
  protocol = "tcp"
  
},
{
  port = 80
  description = "Port 80"
  protocol = "tcp"
  }]
}
