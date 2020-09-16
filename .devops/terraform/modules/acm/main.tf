module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"

  domain_name = var.domain
  zone_id     = var.dns_zone_id

  wait_for_validation = true

  subject_alternative_names = var.alternative_domains

  tags = merge(
    var.common_tags,
    map("Name", "${var.prefix}-acm")
  )
}
