# cloudflare/domain

OpenTofu module that provisions a Cloudflare zone (DNS zone for a domain)
together with its DNS records in a single module call.

## Requirements

- OpenTofu `>= 1.6`
- Cloudflare provider `>= 5.0, < 6.0`
- A Cloudflare API token with `Zone:Edit` and `DNS:Edit` permissions, exposed
  as `CLOUDFLARE_API_TOKEN`

## Usage

```hcl
module "example_com" {
  source = "git::https://github.com/mikinhas/opentofu-cloudflare-modules.git//modules/domain?ref=domain/v0.1.0"

  account_id = "023e105f4ecef8ad9ca31a8372d0c353"
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

output "nameservers" {
  value = module.example_com.name_servers
}
```

After apply, configure the two name servers output above at your domain
registrar — the zone stays in `pending` until Cloudflare detects them.

See [`examples/basic`](./examples/basic) for a runnable example.

## Record names

The `name` field must be the **fully-qualified record name**:

- Apex of `example.com` → `name = "example.com"`
- Subdomain → `name = "www.example.com"`
- Nested → `name = "api.staging.example.com"`

This matches what Cloudflare stores natively — no implicit suffixing.

## Supported record types

`A`, `AAAA`, `CNAME`, `TXT`, `NS`, `MX`, `PTR`.

Types that require a structured `data` payload (`SRV`, `CAA`, `SMIMEA`,
`TLSA`, `SVCB`, `HTTPS`, `DNSKEY`, `DS`, `LOC`, `URI`) are **not supported**
in this version. Manage them separately with `cloudflare_dns_record` if
needed.

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `account_id` | Cloudflare account ID. | `string` | — |
| `name` | Domain name (e.g. `example.com`). | `string` | — |
| `type` | Zone type: `full`, `partial`, or `secondary`. | `string` | `"full"` |
| `paused` | Pause Cloudflare for this zone. | `bool` | `false` |
| `records` | Map of DNS records (see schema below). | `map(object)` | `{}` |

### `records` object schema

| Field | Type | Default | Notes |
|-------|------|---------|-------|
| `name` | `string` | — | Fully-qualified name (e.g. `example.com`, `www.example.com`) |
| `type` | `string` | — | A/AAAA/CNAME/TXT/NS/MX/PTR |
| `content` | `string` | — | IP, target hostname, text value, etc. |
| `ttl` | `number` | `1` | `1` = automatic |
| `proxied` | `bool` | `false` | Only valid for A/AAAA/CNAME |
| `priority` | `number` | `null` | Required for MX |
| `comment` | `string` | `null` | |
| `tags` | `set(string)` | `[]` | |

## Outputs

| Name | Description |
|------|-------------|
| `zone_id` | Cloudflare zone ID. |
| `zone_name` | Zone name (the domain). |
| `name_servers` | Name servers to configure at the registrar. |
| `status` | Zone status (`active`, `pending`, `initializing`, …). |
| `records` | Map of created records: `{ id, name, type, content, proxied }`. |

## Notes

- **Renaming a key** in the `records` map changes the Terraform address and
  forces a drop + recreate of that record. Choose stable keys upfront.
- **TXT records** containing special characters (quotes, semicolons) must be
  enclosed in escaped double quotes in the `content` field, e.g.
  `"\"v=spf1 -all\""`.
- **Proxied records** only work for A, AAAA, and CNAME types. The module
  enforces this with a validation.
