data "aws_route53_zone" "dns_zone" {
  count = local.use_existing_route53_zone ? 1 : 0

  name         = local.domain
  private_zone = false
}

resource "aws_route53_zone" "dns_zone" {
  count = ! local.use_existing_route53_zone ? 1 : 0
  name  = local.domain
}

//data "aws_elb" "default" {
//  name = ""
//  depends_on = [
//    helm_release.ambassador,
//  ]
//}
//
//resource "aws_route53_record" "default" {
//  count   = local.use_existing_route53_zone ? 1 : 0
//  zone_id = data.aws_route53_zone.dns_zone[0].zone_id
//  name    = local.domain
//  type    = "A"
//
//  depends_on = [
//    data.aws_elb.default,
//  ]
//
//  alias {
//    name                   = data.aws_elb.default.dns_name
//    zone_id                = data.aws_elb.default.zone_id
//    evaluate_target_health = false
//  }
//}
