resource "aws_cloudfront_distribution" "this" {
  enabled = true

  price_class = var.price_class

  is_ipv6_enabled     = var.is_ipv6_enabled
  default_root_object = var.default_root_object

  aliases = var.aliases

  dynamic "origin" {
    for_each = [for i in var.s3_origin_config : {
      name          = i.domain_name
      id            = i.origin_id
      identity      = lookup(i, "origin_access_identity", null)
      custom_header = lookup(i, "custom_header", null)
    }]

    content {
      domain_name = origin.value.name
      origin_id   = origin.value.id

      dynamic "custom_header" {
        for_each = origin.value.custom_header == null ? [] : [for i in origin.value.custom_header : {
          name  = i.name
          value = i.value
        }]

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      dynamic "s3_origin_config" {
        for_each = origin.value.identity == null ? [] : [origin.value.identity]

        content {
          origin_access_identity = s3_origin_config.value
        }
      }
    }
  }

  dynamic "origin" {
    for_each = [for i in var.origin_config : {
      name                   = i.domain_name
      id                     = i.origin_id
      http_port              = i.http_port
      https_port             = i.https_port
      origin_protocol_policy = i.origin_protocol_policy
      origin_ssl_protocols   = i.origin_ssl_protocols
      custom_header          = lookup(i, "custom_header", null)
    }]

    content {
      domain_name = origin.value.name
      origin_id   = origin.value.id

      dynamic "custom_header" {
        for_each = origin.value.custom_header == null ? [] : [for i in origin.value.custom_header : {
          name  = i.name
          value = i.value
        }]

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      custom_origin_config {
        http_port              = origin.value.http_port
        https_port             = origin.value.https_port
        origin_protocol_policy = origin.value.origin_protocol_policy
        origin_ssl_protocols   = origin.value.origin_ssl_protocols
      }
    }
  }

  dynamic "default_cache_behavior" {
    for_each = var.default_cache_behavior[*]

    content {
      allowed_methods        = default_cache_behavior.value.allowed_methods
      cached_methods         = default_cache_behavior.value.cached_methods
      target_origin_id       = default_cache_behavior.value.target_origin_id
      viewer_protocol_policy = default_cache_behavior.value.viewer_protocol_policy
      compress               = lookup(default_cache_behavior.value, "compress", null)

      forwarded_values {
        query_string = default_cache_behavior.value.query_string
        headers      = lookup(default_cache_behavior.value, "headers", null)

        cookies {
          forward = default_cache_behavior.value.cookie_forward
        }
      }

      default_ttl = lookup(default_cache_behavior.value, "default_ttl", null)
      min_ttl     = lookup(default_cache_behavior.value, "min_ttl", null)
      max_ttl     = lookup(default_cache_behavior.value, "max_ttl", null)
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations        = var.restriction_locations
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = var.cloudfront_default_certificate
    ssl_support_method             = var.ssl_support_method
  }

  tags = var.common_tags
}
