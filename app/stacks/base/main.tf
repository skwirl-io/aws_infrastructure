locals {
  ssm_parameter_prefix = "/market_back/staging/"
}

module "vpc" {
  source = "../../modules/vpc"
}

module "rds_instance" {
  source = "../../modules/rds_instance"

  db_subnet_group_name  = module.vpc.db_subnet_group_name
  rds_security_group_id = module.vpc.rds_security_group_id
  ssm_parameter_prefix  = local.ssm_parameter_prefix
}

# TODO: rotate and ofuscate
resource "aws_ssm_parameter" "hmac_secret" {
  name        = "${local.ssm_parameter_prefix}HMAC_SECRET"
  description = "hmac secret for Rodauth"
  type        = "SecureString"
  value       = "cbaeecb1b20575852bfb428664040d9ecfe4a6c73d2cece79bb15769449e76093841931d48776e4436d7d218a1a1e5fc6a73ecb82d044e7400b21a083537bfe3"
}

resource "aws_ssm_parameter" "password_pepper" {
  name        = "${local.ssm_parameter_prefix}PASSWORD_PEPPER"
  description = "password pepper for Rodauth"
  type        = "SecureString"
  value       = "0b650267ae61f2be1aa36c5a5ce1c3b1b61709886a51ee53016fb807d0bd935673f8b0aa63267772dab573acb6fbe30c7306081bdf14b7b01d4ec9ef4392fce6"
}

resource "aws_ssm_parameter" "jwt_secret" {
  name        = "${local.ssm_parameter_prefix}JWT_SECRET"
  description = "jwt secret for Rodauth"
  type        = "SecureString"
  value       = "657e57e5784301eeab3dcbfef181d6b86d5c97eb3dd2770ee89f1b656248311c068e45a46e796d254be3cbacfaa96da60426696c99a68d4d5a3978a2b6d4b2d3"
}

resource "aws_ssm_parameter" "front_end_base_url" {
  name        = "${local.ssm_parameter_prefix}FRONT_END_BASE_URL"
  description = "jwt secret for Rodauth"
  type        = "String"
  value       = "https://skwirly-1993.vercel.app/"
}
