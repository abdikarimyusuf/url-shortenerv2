aws_region   = "eu-west-2"
project_name = "url-shortener"
environment  = "dev"

vpc_cidr_block = "10.0.0.0/24"

availability_zones = [
  "eu-west-2a",
  "eu-west-2b"
]

public_subnet_cidr = [
  "10.0.1.0/27",
  "10.0.2.0/27"
]

private_subnet_cidr = [
  "10.0.3.0/27",
  "10.0.4.0/27"
]