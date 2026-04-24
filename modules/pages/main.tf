resource "cloudflare_pages_project" "this" {
  account_id        = var.account_id
  name              = var.name
  production_branch = var.production_branch

  build_config = {
    build_caching   = var.build_caching
    build_command   = var.build_command
    destination_dir = var.destination_dir
    root_dir        = var.root_dir
  }

  source = {
    type = var.git_provider
    config = {
      owner                          = var.git_owner
      repo_name                      = var.git_repo_name
      production_branch              = var.production_branch
      production_deployments_enabled = true
      pr_comments_enabled            = var.pr_comments_enabled
      preview_deployment_setting     = var.preview_deployment_setting
    }
  }

  deployment_configs = {
    production = {
      env_vars = length(var.production_env_vars) > 0 ? var.production_env_vars : null
    }
    preview = {
      env_vars = length(var.preview_env_vars) > 0 ? var.preview_env_vars : null
    }
  }
}

resource "terraform_data" "initial_deployment" {
  triggers_replace = [cloudflare_pages_project.this.id]

  provisioner "local-exec" {
    command = "curl -fsS -X POST -H \"Authorization: Bearer $CLOUDFLARE_API_TOKEN\" https://api.cloudflare.com/client/v4/accounts/${var.account_id}/pages/projects/${cloudflare_pages_project.this.name}/deployments"
  }
}

resource "cloudflare_pages_domain" "this" {
  for_each = var.custom_domains

  account_id   = var.account_id
  project_name = cloudflare_pages_project.this.name
  name         = each.value
}
