variable "account_id" {
  description = "Cloudflare account ID that will own the zone."
  type        = string
}

variable "name" {
  description = "Domain name for the zone (e.g. example.com)."
  type        = string

  validation {
    condition     = can(regex("^([a-z0-9]([a-z0-9-]*[a-z0-9])?\\.)+[a-z]{2,}$", var.name))
    error_message = "name must be a valid lowercase domain (e.g. example.com)."
  }
}

variable "type" {
  description = "Zone type. Use \"full\" when Cloudflare is authoritative for DNS, \"partial\" for CNAME setup, or \"secondary\" for secondary DNS."
  type        = string
  default     = "full"

  validation {
    condition     = contains(["full", "partial", "secondary"], var.type)
    error_message = "type must be one of: full, partial, secondary."
  }
}

variable "paused" {
  description = "Pause Cloudflare for this zone."
  type        = bool
  default     = false
}

variable "records" {
  description = "DNS records to create in the zone. Keyed by a stable local identifier (used as the Terraform address — renaming a key forces recreation). The `name` field must be the fully-qualified record name (e.g. `example.com` for the apex, `www.example.com` for a subdomain)."
  type = map(object({
    name     = string
    type     = string
    content  = string
    ttl      = optional(number, 1)
    proxied  = optional(bool, false)
    priority = optional(number)
    comment  = optional(string)
    tags     = optional(set(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for r in values(var.records) : contains(["A", "AAAA", "CNAME", "TXT", "NS", "MX", "PTR"], r.type)
    ])
    error_message = "record type must be one of: A, AAAA, CNAME, TXT, NS, MX, PTR."
  }

  validation {
    condition = alltrue([
      for r in values(var.records) : r.type != "MX" || r.priority != null
    ])
    error_message = "MX records require priority."
  }

  validation {
    condition = alltrue([
      for r in values(var.records) : !r.proxied || contains(["A", "AAAA", "CNAME"], r.type)
    ])
    error_message = "proxied can only be true for A, AAAA, or CNAME records."
  }
}
