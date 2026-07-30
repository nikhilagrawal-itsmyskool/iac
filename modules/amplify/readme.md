# amplify

AWS Amplify Hosting for a git-connected SPA (Vite/React), with CI/CD on push.

## Auth
`access_token` must be a git provider PAT (GitHub). Do not commit it — pass via
environment, e.g. `AMPLIFY_GITHUB_TOKEN`, read in the terragrunt config with
`get_env("AMPLIFY_GITHUB_TOKEN", "")`.

## Custom domain on Cloudflare
The domain association is created with `wait_for_verification = false`. After apply:

1. `terragrunt output domain_dns_records`
2. Add the `certificate_verification` CNAME and each sub-domain CNAME in Cloudflare
   as **DNS-only (grey cloud)** — Amplify verification/serving does not work behind
   Cloudflare's proxy.
3. Amplify moves the domain to AVAILABLE once the records resolve.

## SPA routing
A `custom_rule` rewrites non-asset paths to `/index.html` (200) so client-side
routing works on deep links / refresh.
