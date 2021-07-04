data "aws_route53_zone" "zone" {
  name = var.domain
}

resource "aws_route53_record" "vercel_cname" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "300"
  records = ["cname.vercel-dns.com"]
}

resource "aws_route53_record" "vercel_a" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = ""
  type    = "A"
  ttl     = "300"
  records = ["76.76.21.21"]
}

resource "aws_route53_record" "vercel_blog_cname" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "blog"
  type    = "CNAME"
  ttl     = "300"
  records = ["cname.vercel-dns.com"]
}
