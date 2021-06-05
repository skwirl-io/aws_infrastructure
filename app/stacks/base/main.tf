module "vpc" {
  source = "../../modules/vpc"
}

module "rds_instance" {
  source = "../../modules/rds_instance"

  db_subnet_group_name  = module.vpc.db_subnet_group_name
  rds_security_group_id = module.vpc.rds_security_group_id
  ssm_parameter_prefix  = var.ssm_parameter_prefix
}

module "route53" {
  source = "../../modules/route53"

  domain = var.domain
}

module "backend_parameters" {
  source = "../../modules/backend_parameters"

  ssm_parameter_prefix  = var.ssm_parameter_prefix
  domain = var.domain
}
