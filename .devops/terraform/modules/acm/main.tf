data "aws_route53_zone" "dns_zone" {
  count = var.use_existing_route53_zone ? 1 : 0

  name         = var.domain
  private_zone = false
}

resource "aws_route53_zone" "dns_zone" {
  count = ! var.use_existing_route53_zone ? 1 : 0
  name  = var.domain
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"

  domain_name = var.domain
  zone_id     = coalescelist(data.aws_route53_zone.dns_zone.*.zone_id, aws_route53_zone.dns_zone.*.zone_id)[0]

  wait_for_validation = true

  subject_alternative_names = [
    "www.${var.domain}",
  ]

  tags = merge(
    var.common_tags,
    map("Name", "${var.prefix}-acm")
  )
}
