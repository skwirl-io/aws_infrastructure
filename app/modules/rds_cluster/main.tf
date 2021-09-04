# max postgres password length is 99
resource "random_password" "db_password" {
  length  = 99
  special = false
  upper   = false
}

resource "aws_rds_cluster" "instance" {
  cluster_identifier = "market-db"

  engine                 = "aurora-postgresql"
  engine_mode            = "serverless"
  enable_http_endpoint   = true
  availability_zones     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.rds_security_group_id]

  database_name   = "market_back"
  master_username = "market_user"
  master_password = random_password.db_password.result


  deletion_protection     = true
  apply_immediately       = true
  backup_retention_period = 1

  scaling_configuration {
    auto_pause   = true
    min_capacity = 2
    max_capacity = 8
  }
}

resource "aws_ssm_parameter" "db_password" {
  name        = "${var.ssm_parameter_prefix}PGPASSWORD"
  description = "RDS password"
  type        = "SecureString"
  value       = random_password.db_password.result
}

resource "aws_ssm_parameter" "db_username" {
  name        = "${var.ssm_parameter_prefix}PGUSER"
  description = "RDS username"
  type        = "String"
  value       = aws_rds_cluster.instance.master_username
}

resource "aws_ssm_parameter" "db_name" {
  name        = "${var.ssm_parameter_prefix}PGDATABASE"
  description = "RDS username"
  type        = "String"
  value       = aws_rds_cluster.instance.database_name
}

resource "aws_ssm_parameter" "db_host" {
  name        = "${var.ssm_parameter_prefix}PGHOST"
  description = "RDS username"
  type        = "String"
  value       = aws_rds_cluster.instance.endpoint
}
