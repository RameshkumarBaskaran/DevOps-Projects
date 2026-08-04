resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-1"
    Environment = var.environment
    Tier        = "Public"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-2"
    Environment = var.environment
    Tier        = "Public"
  }
}
