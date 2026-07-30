# certificate-public-us-east-1-external-dns

us-east-1 public ACM certificate for domains whose DNS is hosted **outside** AWS
(e.g. Cloudflare). Use for edge-optimized API Gateway custom domains / CloudFront,
which require the certificate in us-east-1.

Same two-phase flow as `certificate-public-external-dns`, just pinned to the
`aws.us-east-1` provider alias.

Note: ACM's DNS-validation CNAME for a given domain+account is deterministic, so if
you already validated the same `domain_name` for another cert (e.g. the ap-south-1
one), the required record may already exist in Cloudflare and this cert can validate
immediately.
