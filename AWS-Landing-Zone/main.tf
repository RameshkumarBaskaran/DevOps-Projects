module "vpc" {

  source = "./modules/vpc"

  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets

}
module "bastion" {

  source = "./modules/bastion"

  environment      = var.environment
  public_subnet_id = module.vpc.public_subnet_ids[0]

  security_group_id = module.vpc.bastion_security_group_id

  instance_profile_name = module.iam.instance_profile_name

  ami_id        = var.ami_id
  instance_type = var.instance_type
}
module "iam" {

  source = "./modules/iam"

  environment = var.environment

}