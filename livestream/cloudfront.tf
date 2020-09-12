resource aws_cloudfront_distribution cloudfront_distribution {
  enabled = true
  aliases = var.livestream_cnames
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    target_origin_id       = var.media_store_origin_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      cookies {
        forward = "none"
      }
      headers = [
        "origin",
      ]
      query_string = true
      query_string_cache_keys = [
        "aws.manifestfilter",
        "end",
        "m",
        "start",
      ]
    }
  }

  logging_config {
    bucket          = "livestreaming-logsbucket-1cissxwnrclx8.s3.amazonaws.com"
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
    acm_certificate_arn            = "arn:aws:acm:us-east-1:846656992549:certificate/bf90b147-f940-45e1-aad1-caf192699df4"
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }
}
