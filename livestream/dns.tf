resource aws_route53_zone zone {
  name          = var.livestream_domain
  force_destroy = false
  comment       = "livestream"
}

resource aws_route53_record pointer {
  name    = var.livestream_subdomain
  zone_id = aws_route53_zone.zone.id
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.cloudfront_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
  }
}
