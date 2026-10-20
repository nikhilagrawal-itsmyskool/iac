# cloudflare-r2-bucket

Creates a Cloudflare **R2 bucket** and the **S3-API credentials** for it, and writes those
credentials to **SSM** so the core-api Lambdas can read them (zero-egress object storage for
the parent-facing "Moments" photo feed).

This is the repo's **first non-AWS provider** (`cloudflare`, **v5**). It uses both providers:
- `cloudflare` — the R2 bucket + a **bucket-scoped** account token (credentials via env, see below).
- `aws` (default, from `root.hcl`) — the SSM parameters.

### R2 S3 credentials (bucket-scoped)
The cloudflare provider has no first-class R2 access-key resource, so S3 creds are derived
from a `cloudflare_account_token` scoped to the **"Workers R2 Storage Bucket Item Write"**
permission group on **only this bucket** (resource key
`com.cloudflare.edge.r2.bucket.<account>_<jurisdiction>_<bucket>`). The token cannot touch any
other bucket, DNS, or mint tokens.
- **Access Key ID** = `cloudflare_account_token.r2.id`
- **Secret Access Key** = `sha256(cloudflare_account_token.r2.value)` (SHA-256 **hex** of the value)

### Apply prerequisites (not committed)
Export these before `terragrunt apply` (same convention as `AMPLIFY_GITHUB_TOKEN`):
- `CLOUDFLARE_API_TOKEN` — a bootstrap Cloudflare token with **Account → API Tokens: Edit**
  and **Account → Workers R2 Storage: Edit** (lets Terraform create the bucket + the scoped
  R2 token). Create once in the Cloudflare dashboard.
- `CLOUDFLARE_ACCOUNT_ID` — your Cloudflare account id (also the R2 endpoint host).

### Outputs → SSM
Writes `/<prefix>/<stage>/r2/access_key_id` (String) and `/<prefix>/<stage>/r2/secret_access_key`
(SecureString). The shared `lambda-execution-role` already allows reading `/itsmyskool/prod/*`.

### Consuming in core-api
After apply (params exist), in `core-api/configs/prod/prod.yml`:
```
R2_ENDPOINT: 'https://<account-id>.r2.cloudflarestorage.com'   # or the `endpoint` output
R2_BUCKET: 'prod-itsmyskool-moments'                           # the `bucket` output
R2_ACCESS_KEY_ID: ${ssm:/itsmyskool/prod/r2/access_key_id}
R2_SECRET_ACCESS_KEY: ${ssm:/itsmyskool/prod/r2/secret_access_key}
R2_ENTITY_TYPES: 'outreach'
```
then redeploy the `outreach` module. Do NOT add those lines before this unit is applied —
`prod.yml` is merged into every module, so an unresolvable `${ssm:...}` breaks all deploys.
