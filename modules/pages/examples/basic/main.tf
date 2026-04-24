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

module "site" {
  source = "../.."

  account_id        = var.account_id
  name              = "my-static-site"
  production_branch = "main"

  git_provider  = "github"
  git_owner     = "my-org"
  git_repo_name = "my-static-site"

  build_command   = "npm run build"
  destination_dir = "dist"
  root_dir        = "/"

  custom_domains = ["www.example.com"]

  production_env_vars = {
    NODE_VERSION = { type = "plain_text", value = "20" }
  }

  preview_env_vars = {
    NODE_VERSION = { type = "plain_text", value = "20" }
  }
}

output "pages_url" {
  value = "https://${module.site.subdomain}"
}
