# cloudflare/pages

OpenTofu module that provisions a Cloudflare Pages project backed by a Git
repository (GitHub or GitLab). Cloudflare handles builds and deployments on
every push — production from the configured branch, previews from the others.

## Requirements

- OpenTofu `>= 1.6`
- Cloudflare provider `>= 5.0, < 6.0`
- A Cloudflare API token with `Pages:Edit` permission, exposed as
  `CLOUDFLARE_API_TOKEN`
- The Git provider (GitHub or GitLab) must already be connected to the
  Cloudflare account via the dashboard (one-time OAuth authorization).

## Usage

```hcl
module "site" {
  source = "git::https://github.com/mikinhas/opentofu-cloudflare-modules.git//modules/pages?ref=pages/v0.1.0"

  account_id        = "023e105f4ecef8ad9ca31a8372d0c353"
  name              = "my-static-site"
  production_branch = "main"

  git_provider  = "github"
  git_owner     = "my-org"
  git_repo_name = "my-static-site"

  build_command   = "npm run build"
  destination_dir = "dist"

  production_env_vars = {
    NODE_VERSION = { type = "plain_text", value = "20" }
    API_TOKEN    = { type = "secret_text", value = var.api_token }
  }
}
```

See [`examples/basic`](./examples/basic) for a runnable example.

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `account_id` | Cloudflare account ID. | `string` | — |
| `name` | Pages project name (also the `*.pages.dev` subdomain). | `string` | — |
| `production_branch` | Branch that triggers production deployments. | `string` | `"main"` |
| `git_provider` | `github` or `gitlab`. | `string` | `"github"` |
| `git_owner` | Repository owner (user or organization). | `string` | — |
| `git_repo_name` | Repository name. | `string` | — |
| `pr_comments_enabled` | Post deployment status on PRs. | `bool` | `true` |
| `preview_deployment_setting` | `all`, `none`, or `custom`. | `string` | `"all"` |
| `build_command` | Build command, `null` to skip. | `string` | `null` |
| `destination_dir` | Output directory with built assets. | `string` | `null` |
| `root_dir` | Root directory inside the repo. | `string` | `"/"` |
| `build_caching` | Enable build caching. | `bool` | `true` |
| `production_env_vars` | Env vars for production. Object `{ type, value }`. | `map(object)` | `{}` |
| `preview_env_vars` | Env vars for previews. Object `{ type, value }`. | `map(object)` | `{}` |
| `custom_domains` | Custom domain names to attach to the project. | `set(string)` | `[]` |

Env var `type` must be `plain_text` or `secret_text`.

## Outputs

| Name | Description |
|------|-------------|
| `id` | Pages project ID. |
| `name` | Pages project name. |
| `subdomain` | Default `*.pages.dev` subdomain. |
| `domains` | Custom domains attached to the project. |
| `created_on` | Creation timestamp. |
| `custom_domains` | Map of custom domain → `{ id, status }` for each attached domain. |

## Notes

- Custom domains are attached via `cloudflare_pages_domain`, but the DNS
  record (CNAME to `<name>.pages.dev`, or the zone apex flattening) must be
  created separately — typically with `cloudflare_dns_record`. Until the DNS
  record resolves to Cloudflare, `status` will remain `pending`.
- The Git integration relies on the account-level OAuth connection with the
  provider — the module itself does not create that connection.
