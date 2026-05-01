resource "cloudflare_zone" "this" {
  account = {
    id = var.account_id
  }
  name   = var.name
  type   = var.type
  paused = var.paused
}

resource "cloudflare_dns_record" "this" {
  for_each = var.records

  zone_id  = cloudflare_zone.this.id
  name     = each.value.name
  type     = each.value.type
  content  = each.value.content
  ttl      = each.value.ttl
  proxied  = each.value.proxied
  priority = each.value.priority
  comment  = each.value.comment
  tags     = each.value.tags
}
