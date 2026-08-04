variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones"

  type = list(string)
}

variable "public_subnets" {
  description = "Public Subnet CIDRs"

  type = list(string)
}

variable "private_subnets" {
  description = "Private Subnet CIDRs"

  type = list(string)
}
