module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"

  domain_name = local.domain
  zone_id     = coalescelist(data.aws_route53_zone.dns_zone.*.zone_id, aws_route53_zone.dns_zone.*.zone_id)[0]

  wait_for_validation = true

  subject_alternative_names = []

  tags = merge(
    local.common_tags,
    map("Name", "${local.prefix}-acm")
  )
}
