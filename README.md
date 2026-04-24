# opentofu-cloudflare-modules

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![OpenTofu](https://img.shields.io/badge/OpenTofu-%E2%89%A5%201.6-7B42BC)](https://opentofu.org/)
[![Release Please](https://img.shields.io/badge/release-please-1E90FF)](https://github.com/googleapis/release-please)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-FE5196)](https://www.conventionalcommits.org/)

A collection of [OpenTofu](https://opentofu.org/) modules for provisioning
[Cloudflare](https://www.cloudflare.com/) resources.

Each module lives under [`modules/`](./modules) and is released independently
with its own version tag.

## Modules

| Module | Description |
|--------|-------------|
| [`pages`](./modules/pages) | Cloudflare Pages project connected to a Git repository (GitHub/GitLab), with build config, env vars, and custom domains. |

## Usage

Consume a module with the Git source, pinning to a module-scoped tag:

```hcl
module "site" {
  source = "git::https://github.com/mikinhas/opentofu-cloudflare-modules.git//modules/pages?ref=pages/v0.1.0"

  # ... module inputs
}
```

Each module's `README.md` documents its inputs, outputs, and runnable example.

## Requirements

- OpenTofu `>= 1.6`
- Cloudflare provider `>= 5.0, < 6.0`
- A Cloudflare API token exposed as `CLOUDFLARE_API_TOKEN`

Individual modules may impose additional requirements — see their README.

## Versioning & releases

Modules are versioned **independently** following [Semantic Versioning](https://semver.org/).
Tags are prefixed with the module name: `pages/v1.2.0`, `dns/v0.3.1`, etc.

Releases are managed by [release-please](https://github.com/googleapis/release-please):
commits following the [Conventional Commits](https://www.conventionalcommits.org/)
specification drive automated version bumps and changelog generation.

Scope your commits with the module name so only that module is bumped:

```
feat(pages): add support for build watch paths
fix(pages): correct default for build_caching
feat(pages)!: rename variable git_repo_name → repository
```

## Contributing

Contributions are welcome. See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for the
commit convention, PR workflow, and release process.

## License

[MIT](./LICENSE)
