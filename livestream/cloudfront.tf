resource aws_cloudfront_distribution cloudfront_distribution {
  enabled         = true
  aliases         = ["${var.livestream_subdomain}.${var.livestream_domain}"]
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    target_origin_id       = var.media_store_origin_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      cookies {
        forward = "none"
      }
      headers      = []
      query_string = false
    }
  }

  logging_config {
    bucket          = aws_s3_bucket.logging_bucket.bucket_domain_name
    include_cookies = false
    prefix          = "cloudfront"
  }

  origin {
    domain_name = replace(aws_media_store_container.media_store_container.endpoint, "https://", "")
    origin_id   = var.media_store_origin_id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.certificate.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }
}
