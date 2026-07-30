# certificate-public-external-dns

Public ACM certificate for domains whose DNS is hosted **outside** AWS (e.g. Cloudflare).

Does not touch Route53. You add the validation CNAME(s) at your DNS provider yourself.

## Usage (two-phase)

1. `wait_for_validation = false` -> `terragrunt apply`
2. `terragrunt output validation_records` -> add each CNAME in Cloudflare as **DNS-only (grey cloud)**
3. `wait_for_validation = true` -> `terragrunt apply` (blocks until ISSUED)

The validation CNAMEs are unique `_xxxx.itsmyskool.com` records; they do not collide
with or disturb any existing live records (e.g. Cloudflare Tunnel entries).
