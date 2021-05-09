resource "aws_security_group" "lambda_sg" {
  name        = "default-lambda-sg"
  description = "default security group for lambdas"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "lambda_sg_to_rds_sg" {
  security_group_id        = aws_security_group.lambda_sg.id
  type                     = "egress"
  description              = "Allow postgres connections"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "security group for rds instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow postgres connections"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]
  }
}
