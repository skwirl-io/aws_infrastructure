data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# currently requires manually attaching instance profile
resource "aws_cloud9_environment_ec2" "cloud9" {
  name                        = "Cloud 9 Environment"
  instance_type               = "t2.micro"
  automatic_stop_time_minutes = 30
  description                 = "Cloud 9 Environment with access to jets console"
  subnet_id                   = var.subnet_id
}

data "aws_instance" "cloud9" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
    aws_cloud9_environment_ec2.cloud9.id]
  }
}

resource "aws_iam_role" "cloud9" {
  name = "cloud9_role"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "MarketBackResourceAccess"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ssm:GetParameter*",
          ]
          Effect   = "Allow"
          Resource = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${var.ssm_parameter_prefix}*"
        },
        {
          Action = [
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:DeleteObject"
          ]
          Effect   = "Allow"
          Resource = "${var.public_assets_arn}*"
        }
      ]
    })
  }
}

resource "aws_iam_instance_profile" "cloud9" {
  name = "Cloud9Profile"
  role = aws_iam_role.cloud9.name
}

resource "aws_network_interface_sg_attachment" "cloud9" {
  security_group_id    = var.sg_id
  network_interface_id = data.aws_instance.cloud9.network_interface_id
}
