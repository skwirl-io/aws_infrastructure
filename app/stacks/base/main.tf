module "vpc" {
  source = "../../modules/vpc"

  ssm_parameter_prefix = var.ssm_parameter_prefix
}

<% if Terraspace.env == 'production' %>
module "rds_cluster" {
  source = "../../modules/rds_cluster"

  db_subnet_group_name  = module.vpc.db_subnet_group_name
  rds_security_group_id = module.vpc.rds_security_group_id
  ssm_parameter_prefix  = var.ssm_parameter_prefix
}
<% else %>
module "rds_instance" {
  source = "../../modules/rds_instance"

  db_subnet_group_name  = module.vpc.db_subnet_group_name
  rds_security_group_id = module.vpc.rds_security_group_id
  ssm_parameter_prefix  = var.ssm_parameter_prefix
}
<% end %>

module "s3" {
  source = "../../modules/s3"

  domain               = var.domain
  public_assets_bucket = var.public_assets_bucket
  ssm_parameter_prefix = var.ssm_parameter_prefix
}

module "route53" {
  source = "../../modules/route53"

  domain               = var.domain
  ssm_parameter_prefix = var.ssm_parameter_prefix
}

module "backend_parameters" {
  source = "../../modules/backend_parameters"

  domain               = var.domain
  ssm_parameter_prefix = var.ssm_parameter_prefix
}

module "cloud9_instance" {
  source = "../../modules/cloud9_instance"

  subnet_id = module.vpc.public_subnet_a_id
  ssm_parameter_prefix = var.ssm_parameter_prefix
  public_assets_arn = module.s3.public_assets_arn
  sg_id = module.vpc.lambda_sg_id
}
