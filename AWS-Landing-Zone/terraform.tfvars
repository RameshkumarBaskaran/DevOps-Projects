aws_region = "ap-south-1"

environment = "dev"

vpc_cidr = "10.0.0.0/16"

availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

ami_id = "ami-0f58b397bc5c1f2e8"

instance_type = "t2.micro"
public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDReplaceWithYourRealPublicKey"
db_username   = "admin"

db_password = "ChangeMe123!"
domain_name = "awslandingzone.local"