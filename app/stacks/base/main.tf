module "vpc" {
  source = "../../modules/vpc"
}

module "rds_instance" {
  source = "../../modules/rds_instance"

  db_subnet_group_name  = module.vpc.db_subnet_group_name
  rds_security_group_id = module.vpc.rds_security_group_id
  ssm_parameter_prefix  = "/market_back/staging/"
}
