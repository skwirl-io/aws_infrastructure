resource "aws_s3_bucket" "public_assets" {
  bucket = var.public_assets_bucket
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  versioning {
    enabled = true
  }
}

data "aws_route53_zone" "zone" {
  name = var.domain
}

resource "aws_acm_certificate" "assets_domain_cert" {
  domain_name       = "assets.${var.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "assets_domain_cert" {
  for_each = {
    for dvo in aws_acm_certificate.assets_domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "assets_domain_cert" {
  certificate_arn         = aws_acm_certificate.assets_domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.assets_domain_cert : record.fqdn]
}

resource "aws_cloudfront_distribution" "public_assets" {
  enabled         = true
  is_ipv6_enabled = true

  aliases = ["assets.${var.domain}"]

  origin {
    domain_name = aws_s3_bucket.public_assets.bucket_domain_name
    origin_id   = "assetsBucket"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    target_origin_id = "assetsBucket"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 7200
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.assets_domain_cert.arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "public_assets_record_A" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "assets.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.public_assets.domain_name
    zone_id                = aws_cloudfront_distribution.public_assets.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "public_assets_record_AAAA" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "assets.${var.domain}"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.public_assets.domain_name
    zone_id                = aws_cloudfront_distribution.public_assets.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_ssm_parameter" "public_assets" {
  name        = "${var.ssm_parameter_prefix}PUBLIC_ASSETS_BUCKET"
  description = "Public assets bucket name"
  type        = "String"
  value       = aws_s3_bucket.public_assets.id
}
