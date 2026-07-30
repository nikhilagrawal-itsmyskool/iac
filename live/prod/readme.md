# live/prod

Production stack for itsmyskool, in the dedicated prod AWS account
(`264318271546`, profile `prod-itsmyskool-nikhil.agrawal`, region `ap-south-1`).

Everything lands on **new** hostnames so the live Cloudflare-tunnel offering
(`api.itsmyskool.com`, `dbpasn.itsmyskool.com`) stays up untouched:

| Component     | Service                    | Prod hostname                 |
|---------------|----------------------------|-------------------------------|
| core-api      | Lambda + API Gateway (sls) | `api-prod.itsmyskool.com`     |
| admin-portal  | Amplify Hosting            | `dbpasn-prod.itsmyskool.com`  |

DNS stays on **Cloudflare** (authoritative). AWS never manages DNS; you add a few
CNAMEs in Cloudflare as **DNS-only (grey cloud)**. None collide with live records.

---

## Prereqs
- prod AWS profile configured at `/home/nikhil/.aws/credentials`.
- Terragrunt auto-creates the state bucket `264318271546-itsmyskool-terraform-state`
  and lock table `itsmyskool-lock-table` on first `init`.
- `export AMPLIFY_GITHUB_TOKEN=ghp_xxx` (repo + admin:repo_hook scopes) before touching
  `amplify-admin-portal`.

## Apply order (run per-unit from each dir)
```
network
security-group
postgresql-public-subnet
certificate-api-prod-itsmyskool-com   # two-phase, see below
lambda-layer-core-ds
sqs-simple-all / sqs-fifo-all
sns-simple-all / sns-fifo-all
sns-fifo-subscription-all             # after the fifo queue + topic exist
amplify-admin-portal
budget-monthly                        # $20/mo cost budget + email alerts (no deps)
```

## 1. Data layer
`terragrunt apply` network -> security-group -> postgresql-public-subnet.
RDS is public + SG-restricted (`allow_postgresql_from_all`), Graviton `db.t4g.micro`,
db `itsmyskool_prod` / user `postgres`. Grab the endpoint:
`terragrunt output` in postgresql-public-subnet.

Migrate data from the local prod DB (use the sibling `db-backup` repo):
`pg_dump` local `itsmyskool_prod` -> `pg_restore`/`psql` into the RDS endpoint.

## 2. API cert (Cloudflare-validated, two-phase)
In `certificate-api-prod-itsmyskool-com/`:
1. `terragrunt apply` (module default `wait_for_validation = false`).
2. `terragrunt output validation_records` -> add the CNAME in Cloudflare (**DNS-only**).
3. Edit terragrunt.hcl -> `wait_for_validation = true` -> `terragrunt apply` (waits until ISSUED).

## 3. core-api -> Lambda + API Gateway (serverless, in core-api repo)
Wire prod config first (in `core-api`):
- `configs/prod/prod.yml` -> set `POSTGRES_ENDPOINT` (+ readonly) to the RDS endpoint,
  `POSTGRES_USERNAME: postgres`, `POSTGRES_PASSWORD: itsmyskool`,
  `POSTGRES_DATABASE: itsmyskool_prod`, `POSTGRES_SSL: 'true'`.
- `modules/global-config-prod.yml` -> add a `custom.customDomains` block:
  ```yaml
  custom:
    customDomains:
      - rest:
          domainName: api-prod.itsmyskool.com
          certificateName: api-prod.itsmyskool.com
          createRoute53Record: false     # DNS is on Cloudflare
          endpointType: regional
          basePath: 'sample'
  ```
Then:
```
sls create_domain --stage prod          # once; prints the API GW target domain
```
CNAME `api-prod.itsmyskool.com` -> that `d-xxxx.execute-api.ap-south-1.amazonaws.com`
target in Cloudflare. Use **DNS-only**, or proxied with SSL mode **Full (strict)**
(the ACM cert from step 2 covers the origin leg).
```
sls deploy --stage prod                 # per module, or your deploy-all
```
Validate directly at `https://api-prod.itsmyskool.com/<basePath>/health`.

## 4. admin-portal -> Amplify (in amplify-admin-portal/)
`export AMPLIFY_GITHUB_TOKEN=...` then `terragrunt apply`. Amplify connects the repo,
builds `main`, and overwrites `.env.production` so the SPA targets `api-prod`.
- Validate at the branch URL: `terragrunt output app_url`
  (`https://main.<appid>.amplifyapp.com`).
- Attach the domain: `terragrunt output domain_dns_records` -> add the
  `certificate_verification` CNAME and the `dbpasn-prod` sub-domain CNAME in Cloudflare
  (**DNS-only**). Amplify flips the domain to AVAILABLE, serving
  `https://dbpasn-prod.itsmyskool.com`.

## Notes
- No bastion / key-pair in prod: RDS is publicly reachable for migration + ops.
- No flip of the live `api`/`dbpasn` records happens here — this is a parallel stack.
  Cut those over later (separate, reversible) once you're satisfied.
- `s3:PutObject/GetObject` in the core-api IAM has no bucket here yet; add a
  `bucket-private` unit if the app writes uploads (documents, barcodes, exports).
```
