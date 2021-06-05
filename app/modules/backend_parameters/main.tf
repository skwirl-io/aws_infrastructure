resource "random_password" "hmac_secret" {
  length  = 128
  special = false
  upper   = false
}

resource "aws_ssm_parameter" "hmac_secret" {
  name        = "${var.ssm_parameter_prefix}HMAC_SECRET"
  description = "hmac secret for Rodauth"
  type        = "SecureString"
  value       = random_password.hmac_secret.result
}

resource "random_password" "password_pepper" {
  length  = 128
  special = false
  upper   = false
}

resource "aws_ssm_parameter" "password_pepper" {
  name        = "${var.ssm_parameter_prefix}PASSWORD_PEPPER"
  description = "password pepper for Rodauth"
  type        = "SecureString"
  value       = random_password.password_pepper.result
}

resource "random_password" "jwt_secret" {
  length  = 128
  special = false
  upper   = false
}

resource "aws_ssm_parameter" "jwt_secret" {
  name        = "${var.ssm_parameter_prefix}JWT_SECRET"
  description = "jwt secret for Rodauth"
  type        = "SecureString"
  value       = random_password.jwt_secret.result
}

resource "aws_ssm_parameter" "front_end_base_url" {
  name        = "${var.ssm_parameter_prefix}FRONT_END_BASE_URL"
  description = "base url of the frontend"
  type        = "String"
  value       = "https://${var.domain}"
}

resource "aws_ssm_parameter" "rodauth_email" {
  name        = "${var.ssm_parameter_prefix}RODAUTH_EMAIL"
  description = "base url of the frontend"
  type        = "String"
  value       = "accounts@${var.domain}"
}

resource "aws_ssm_parameter" "default_email" {
  name        = "${var.ssm_parameter_prefix}DEFAULT_EMAIL"
  description = "base url of the frontend"
  type        = "String"
  value       = "info@${var.domain}"
}
