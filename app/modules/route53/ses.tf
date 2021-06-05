resource "aws_ses_domain_identity" "email_domain" {
  domain = var.domain
}

resource "aws_ses_domain_dkim" "email_domain_dkim" {
  domain = aws_ses_domain_identity.email_domain.domain
}

resource "aws_route53_record" "email_dkim_record" {
  count   = 3
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${element(aws_ses_domain_dkim.email_domain_dkim.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.email_domain_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
