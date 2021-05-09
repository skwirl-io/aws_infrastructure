locals {
  db_password = "zNLv2jd3s2Ob47jC"
}

resource "aws_db_instance" "instance" {
  identifier = "market-db"

  storage_type      = "gp2"
  allocated_storage = 10
  engine            = "postgres"
  engine_version    = "12.6"
  instance_class    = "db.t2.micro"
  name              = "market_back"
  username          = "market_user"
  password          = local.db_password

  skip_final_snapshot     = true
  apply_immediately       = true
  backup_retention_period = 0

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.rds_security_group_id]
  multi_az               = false
}

resource "aws_ssm_parameter" "db_password" {
  name        = "${var.ssm_parameter_prefix}PGPASSWORD"
  description = "RDS password"
  type        = "SecureString"
  value       = local.db_password
}

resource "aws_ssm_parameter" "db_username" {
  name        = "${var.ssm_parameter_prefix}PGUSER"
  description = "RDS username"
  type        = "String"
  value       = aws_db_instance.instance.username
}

resource "aws_ssm_parameter" "db_name" {
  name        = "${var.ssm_parameter_prefix}PGDATABASE"
  description = "RDS username"
  type        = "String"
  value       = aws_db_instance.instance.name
}

resource "aws_ssm_parameter" "db_host" {
  name        = "${var.ssm_parameter_prefix}PGHOST"
  description = "RDS username"
  type        = "String"
  value       = aws_db_instance.instance.address
}
