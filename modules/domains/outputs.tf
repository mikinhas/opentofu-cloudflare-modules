output "zone_id" {
  description = "Cloudflare zone ID."
  value       = cloudflare_zone.this.id
}

output "zone_name" {
  description = "Zone name (the domain)."
  value       = cloudflare_zone.this.name
}

output "name_servers" {
  description = "Cloudflare name servers assigned to the zone. Configure these at your registrar to complete the zone activation."
  value       = cloudflare_zone.this.name_servers
}

output "status" {
  description = "Zone status (active, pending, initializing, etc.)."
  value       = cloudflare_zone.this.status
}

output "records" {
  description = "Map of created DNS records keyed by local identifier."
  value = {
    for k, r in cloudflare_dns_record.this : k => {
      id      = r.id
      name    = r.name
      type    = r.type
      content = r.content
      proxied = r.proxied
    }
  }
}
