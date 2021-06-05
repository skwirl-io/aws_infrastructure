resource "aws_ssm_parameter" "private_subnet_id_list" {
  name        = "${var.ssm_parameter_prefix}PRIVATE_SUBNET_ID_LIST"
  description = "comma seperated list of private subnet ids"
  type        = "String"
  value       = "${aws_subnet.private_a.id},${aws_subnet.private_b.id},${aws_subnet.private_c.id}"
}

resource "aws_ssm_parameter" "lambda_sg_id" {
  name        = "${var.ssm_parameter_prefix}LAMBDA_SG_ID"
  description = "default lambda sg id"
  type        = "String"
  value       = aws_security_group.lambda_sg.id
}
