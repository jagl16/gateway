data "aws_route53_zone" "this" {
  count   = (var.zone_id != null || var.zone_name != null) ? 1 : 0
  zone_id = var.zone_id
  name    = var.zone_name
}

resource "aws_route53_record" "this" {
  for_each = { for record in var.records : join(" ", [record.name, record.type]) => record }

  zone_id = data.aws_route53_zone.this[0].zone_id

  name    = each.value.name
  type    = each.value.type
  ttl     = lookup(each.value, "ttl", null)
  records = lookup(each.value, "records", null)

  dynamic "alias" {
    for_each = length(keys(lookup(each.value, "alias", {}))) == 0 ? [] : [true]

    content {
      name                   = each.value.alias.name
      zone_id                = each.value.alias.zone_id
      evaluate_target_health = lookup(each.value.alias, "evaluate_target_health", false)
    }
  }
}
