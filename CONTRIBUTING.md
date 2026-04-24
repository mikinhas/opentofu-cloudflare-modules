# Contributing

Thanks for your interest in contributing! This repository hosts OpenTofu
modules for Cloudflare, each released independently via
[release-please](https://github.com/googleapis/release-please).

## Commit messages

All commits must follow the [Conventional Commits](https://www.conventionalcommits.org/)
specification. The commit `type` and `scope` drive automatic version bumps and
changelog entries, so they matter.

### Format

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

### Types

| Type | Effect on version | Use for |
|------|-------------------|---------|
| `feat` | Minor bump (`0.1.0` → `0.2.0`) | New feature or input/output |
| `fix` | Patch bump (`0.1.0` → `0.1.1`) | Bug fix |
| `docs` | No bump | README / docs changes |
| `refactor` | No bump | Internal rewrite, no behaviour change |
| `test` | No bump | Adding or fixing tests |
| `chore` | No bump | Tooling, CI, repo maintenance |
| `ci` | No bump | CI pipeline changes |

A `!` after the type/scope **or** a `BREAKING CHANGE:` footer triggers a major
bump (`0.2.0` → `1.0.0`).

### Scope = module name

The scope **must** be the name of the module touched by the commit. This is
what tells release-please which module to bump.

```
feat(pages): add support for build watch paths
fix(pages): correct default for build_caching
feat(pages)!: rename variable git_repo_name → repository
docs(pages): clarify custom_domains DNS requirement
```

For repo-wide changes that don't touch any module (tooling, top-level README,
CI), omit the scope:

```
chore: bump release-please action to v4
docs: add module list to root README
```

## Pull requests

- One module per PR when possible — keeps the release PRs clean
- Update the module's `README.md` (inputs/outputs tables) if you change its
  interface
- Add or update an example under `modules/<module>/examples/` if the change
  affects usage

## Releases

You don't publish releases manually. On every push to `main`:

1. release-please opens (or updates) a **Release PR** per module that has
   unreleased commits
2. Merging that PR creates the tag (`<module>/vX.Y.Z`) and the GitHub Release
3. The tag is then usable as `ref=` in consumer projects

## License

By contributing you agree that your contributions will be licensed under the
repository's [MIT License](./LICENSE).
