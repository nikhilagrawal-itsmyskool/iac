# cloudfront-static-site

A private S3 bucket served over HTTPS by CloudFront on a custom domain (DNS on Cloudflare).

- Bucket is **fully private**; only this CloudFront distribution reads it (OAC + SourceArn).
- Bucket name can be **anything** (no S3-website host-routing constraint).
- HTTPS end-to-end via a **us-east-1 ACM cert** (pass its ARN; CloudFront requires us-east-1).
- Single-page friendly: 403/404 serve `index.html` (short error TTL).
- Content is **not** Terraform-managed — upload with `aws s3 cp` so releases don't churn state.

## Wiring (Cloudflare DNS)
1. Create the ACM cert (`certificate-public-us-east-1-external-dns`) and add its validation
   CNAME in Cloudflare (DNS-only), then set `wait_for_validation = true` and re-apply.
2. Apply this module with that cert's ARN.
3. CNAME the custom domain to `distribution_domain_name` in Cloudflare (DNS-only is fine —
   CloudFront already terminates TLS).
4. Upload content: `aws s3 cp index.html s3://<bucket>/` etc., then invalidate if needed:
   `aws cloudfront create-invalidation --distribution-id <id> --paths '/*'`.
