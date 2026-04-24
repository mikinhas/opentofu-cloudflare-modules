output "id" {
  description = "Cloudflare Pages project ID."
  value       = cloudflare_pages_project.this.id
}

output "name" {
  description = "Pages project name."
  value       = cloudflare_pages_project.this.name
}

output "subdomain" {
  description = "Default *.pages.dev subdomain assigned to the project."
  value       = cloudflare_pages_project.this.subdomain
}

output "domains" {
  description = "Custom domains attached to the project."
  value       = cloudflare_pages_project.this.domains
}

output "created_on" {
  description = "Creation timestamp of the project."
  value       = cloudflare_pages_project.this.created_on
}

output "custom_domains" {
  description = "Map of custom domain name to its verification status."
  value = {
    for k, d in cloudflare_pages_domain.this : k => {
      id     = d.id
      status = d.status
    }
  }
}
