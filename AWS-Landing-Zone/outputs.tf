output "aws_region" {
  value = var.aws_region
}

output "environment" {
  value = var.environment
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
