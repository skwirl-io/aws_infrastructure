output "db_subnet_group_name" {
  value = aws_db_subnet_group.private.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}
