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
module "app_server" {

  source = "./modules/ec2"

  name = "${var.environment}-app-server"

  environment = var.environment

  ami_id = var.ami_id

  instance_type = var.instance_type

  subnet_id        = module.vpc.private_subnet_ids[0]
  target_group_arn = module.vpc.target_group_arn

  security_group_ids = [
    module.vpc.app_security_group_id
  ]
  instance_profile_name = module.iam.instance_profile_name
  public_key            = var.public_key
}