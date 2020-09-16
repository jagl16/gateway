module "web_app" {
  source = "../../applications/web-app"

  domain          = var.app_domain
  dns_root_domain = var.root_domain
  prefix          = var.prefix
  dns_zone_id     = coalescelist(data.aws_route53_zone.dns_zone.*.zone_id, aws_route53_zone.dns_zone.*.zone_id)[0]
}
