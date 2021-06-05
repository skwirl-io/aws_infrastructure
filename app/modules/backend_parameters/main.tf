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
  value       = "https://skwirlhouse1.ca"
}
