provider "aws" {

  region = var.aws_region

  default_tags {

    tags = {

      Environment = var.environment
      Project     = "Enterprise-Landing-Zone"
      ManagedBy   = "Terraform"

    }

  }

}
