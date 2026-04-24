terraform {
  required_version = ">= 1.6.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.0.0, < 6.0.0"
    }
  }
}

provider "cloudflare" {
  # Set CLOUDFLARE_API_TOKEN in the environment.
}

variable "account_id" {
  type = string
}

module "example_com" {
  source = "../.."

  account_id = var.account_id
  name       = "example.com"

  records = {
    root_a = {
      name    = "example.com"
      type    = "A"
      content = "192.0.2.1"
      proxied = true
    }
    www_cname = {
      name    = "www.example.com"
      type    = "CNAME"
      content = "example.com"
      proxied = true
    }
    spf = {
      name    = "example.com"
      type    = "TXT"
      content = "\"v=spf1 -all\""
    }
    mx_primary = {
      name     = "example.com"
      type     = "MX"
      content  = "mail.example.com"
      priority = 10
    }
  }
}

output "name_servers" {
  value = module.example_com.name_servers
}

output "zone_id" {
  value = module.example_com.zone_id
}
