provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Enterprise-Landing-Zone"
      Environment = var.environment
      Owner       = "Ramesh"
      ManagedBy   = "Terraform"
    }
  }
}
