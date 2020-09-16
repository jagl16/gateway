provider "aws" {
  alias  = "us-east"
  region = "us-east-1"
}

module "acm" {
  source = "../../modules/acm"
  providers = {
    aws = aws.us-east
  }

  dns_zone_id = var.dns_zone_id
  domain      = var.domain
  common_tags = var.common_tags
  prefix      = var.prefix
}

module "s3" {
  source = "../../modules/s3"

  # Note: The bucket name needs to carry the same name as the domain!
  # http://stackoverflow.com/a/5048129/2966951
  bucket      = var.domain
  common_tags = var.common_tags

  policy = <<EOF
{
  "Version":"2008-10-17",
  "Statement":[{
    "Sid":"AllowPublicRead",
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::${var.domain}/*"]
  }]
}
EOF

  website = {
    index_document = "index.html"
  }
}

module "cf" {
  source = "../../modules/cf"

  s3_origin_config = [
    {
      domain_name = "${var.domain}.s3.amazonaws.com"
      origin_id   = "origin.${var.domain}"
    }
  ]

  aliases = [
    var.domain,
  ]

  acm_certificate_arn = module.acm.acm_certificate_arn

  default_cache_behavior = [
    {
      allowed_methods        = ["GET", "HEAD", "OPTIONS"]
      cached_methods         = ["GET", "HEAD"]
      target_origin_id       = "origin.${var.domain}"
      compress               = false
      query_string           = true
      cookie_forward         = "none"
      viewer_protocol_policy = "redirect-to-https"
      default_ttl            = 3600
      min_ttl                = 0
      max_ttl                = 86400
    }
  ]

  common_tags = var.common_tags
}

module "route53" {
  source = "../../modules/route53"

  zone_name = var.dns_root_domain

  records = [
    {
      name = var.domain
      type = "A"

      alias = {
        name    = module.cf.domain_name
        zone_id = module.cf.hosted_zone_id
      }
    },
  ]

  common_tags = var.common_tags
}

locals {
  source_dir = "${pathexpand("/src/web-app")}/out"
  content_type_map = {
    html = "text/html",
    js   = "application/javascript",
    css  = "text/css",
    svg  = "image/svg+xml",
    jpg  = "image/jpeg",
    ico  = "image/x-icon",
    png  = "image/png",
    gif  = "image/gif",
    pdf  = "application/pdf"
  }
}

#https://github.com/terraform-providers/terraform-provider-aws/issues/3020
resource "aws_s3_bucket_object" "file_upload" {
  for_each = fileset(local.source_dir, "**")

  bucket       = module.s3.bucket_id[0]
  key          = each.value
  source       = "${local.source_dir}/${each.value}"
  etag         = filemd5("${local.source_dir}/${each.value}")
  content_type = lookup(local.content_type_map, regex("\\.(?P<extension>[A-Za-z0-9]+)$", each.value).extension, "text/html")
}
