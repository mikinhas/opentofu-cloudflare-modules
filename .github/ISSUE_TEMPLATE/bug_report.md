---
name: Bug report
about: Report a problem with a module
title: "[bug] "
labels: bug
---

## Module

<!-- Which module is affected? e.g. modules/pages -->

## Versions

- Module version (tag): <!-- e.g. pages/v0.1.0 -->
- OpenTofu version: <!-- `tofu version` -->
- Cloudflare provider version:

## What happened?

<!-- Describe the actual behaviour -->

## What did you expect?

<!-- Describe the expected behaviour -->

## Reproduction

<!--
Minimal OpenTofu config + commands that reproduce the issue.
Redact any secrets (API tokens, account IDs you don't want public).
-->

```hcl
module "example" {
  source = "..."
  # ...
}
```

## Logs / errors

<!-- Paste relevant `tofu plan` / `tofu apply` output -->

```
```
