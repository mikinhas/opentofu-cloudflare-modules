variable "account_id" {
  description = "Cloudflare account ID owning the Pages project."
  type        = string
}

variable "name" {
  description = "Pages project name. Also determines the default *.pages.dev subdomain."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,57}[a-z0-9]$", var.name))
    error_message = "name must be lowercase alphanumeric with hyphens, 2-58 chars, not starting or ending with a hyphen."
  }
}

variable "production_branch" {
  description = "Branch that triggers production deployments."
  type        = string
  default     = "main"
}

variable "git_provider" {
  description = "Git provider hosting the source repository."
  type        = string
  default     = "github"

  validation {
    condition     = contains(["github", "gitlab"], var.git_provider)
    error_message = "git_provider must be either \"github\" or \"gitlab\"."
  }
}

variable "git_owner" {
  description = "Owner (user or organization) of the source repository."
  type        = string
}

variable "git_repo_name" {
  description = "Name of the source repository."
  type        = string
}

variable "pr_comments_enabled" {
  description = "Post deployment status comments on pull requests."
  type        = bool
  default     = true
}

variable "preview_deployment_setting" {
  description = "Which non-production branches get preview deployments: all, none, or custom."
  type        = string
  default     = "all"

  validation {
    condition     = contains(["all", "none", "custom"], var.preview_deployment_setting)
    error_message = "preview_deployment_setting must be one of: all, none, custom."
  }
}

variable "build_command" {
  description = "Command executed to build the site. Leave null for no-build static sites."
  type        = string
  default     = null
}

variable "destination_dir" {
  description = "Directory (relative to root_dir) containing the built static assets to publish."
  type        = string
  default     = null
}

variable "root_dir" {
  description = "Root directory of the project within the repository."
  type        = string
  default     = "/"
}

variable "build_caching" {
  description = "Enable Cloudflare Pages build caching."
  type        = bool
  default     = true
}

variable "production_env_vars" {
  description = "Environment variables for production deployments. Use type=secret_text for secrets."
  type = map(object({
    type  = string
    value = string
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.production_env_vars) : contains(["plain_text", "secret_text"], v.type)])
    error_message = "Each production env var type must be \"plain_text\" or \"secret_text\"."
  }
}

variable "preview_env_vars" {
  description = "Environment variables for preview deployments. Use type=secret_text for secrets."
  type = map(object({
    type  = string
    value = string
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.preview_env_vars) : contains(["plain_text", "secret_text"], v.type)])
    error_message = "Each preview env var type must be \"plain_text\" or \"secret_text\"."
  }
}

variable "custom_domains" {
  description = "Custom domains to attach to the Pages project. DNS records pointing each domain at <name>.pages.dev must exist separately."
  type        = set(string)
  default     = []
}
