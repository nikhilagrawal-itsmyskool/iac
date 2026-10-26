# cloudflare-worker-proxy

A Cloudflare **Worker** that bridges an **HTTP-only biometric device** to our **HTTPS prod API**.

The attendance biometric device can only speak plain HTTP and is hard-wired to a fixed root
path (`/iclock/...`). Our prod API Gateway is HTTPS-only and serves the same handlers under
`/biometric`. This unit stands up:

- a **proxied CNAME** (`biometric.itsmyskool.com`, orange-cloud) so Cloudflare terminates the
  device's HTTP request at the edge,
- a **Worker** (service-worker syntax, see `worker.js`) that rewrites `/iclock/*` ->
  `/biometric/*`, sets the origin host to the prod API custom domain, and forwards over HTTPS,
- a **Worker route** binding the Worker to every request on that hostname.

Net effect: the device talks **HTTP** to Cloudflare's edge; Cloudflare talks **HTTPS** to our
origin (`api-prod.itsmyskool.com`). The `Host` header is derived from the rewritten URL so API
Gateway's custom-domain mapping resolves correctly.

This uses the **cloudflare v5** provider (`~> 5.0`, pinned 5.28.0). Only the cloudflare provider
is used — no AWS resources are created (the aws provider from `root.hcl` is simply unused here).

### Variables
| name | default | description |
|------|---------|-------------|
| `cloudflare_account_id` | — | account that owns the Worker script |
| `zone_id` | — | zone id for `itsmyskool.com` (DNS record + route) |
| `worker_name` | `biometric-iclock-proxy` | Worker script name |
| `record_name` | `biometric.itsmyskool.com` | hostname the device hits |
| `origin_host` | `api-prod.itsmyskool.com` | HTTPS origin the Worker forwards to |
| `tags` | `{}` | optional, convention/parity only |

### Apply prerequisites (not committed)
Export these before `terragrunt apply` (same env-var convention as `CLOUDFLARE_API_TOKEN` in
the r2 unit):

- `CLOUDFLARE_API_TOKEN` — a Cloudflare token scoped to:
  - **Account → Workers Scripts: Edit** (create/update the Worker),
  - **Zone → Workers Routes: Edit** (bind the route) for the `itsmyskool.com` zone,
  - **Zone → DNS: Edit** for the `itsmyskool.com` zone (the proxied CNAME).
- `CLOUDFLARE_ACCOUNT_ID` — the Cloudflare account id.
- `CLOUDFLARE_ZONE_ID` — the `itsmyskool.com` zone id.
- `AWS_PROFILE=prod-itsmyskool-nikhil.agrawal` — so the S3 remote-state backend inits.

The token is read from `CLOUDFLARE_API_TOKEN` by the provider at apply time; it is never
committed (the generated `provider "cloudflare" {}` block has no inline credentials).

### Outputs
`worker_name`, `route_pattern`, `record_name`, `origin_host`.
