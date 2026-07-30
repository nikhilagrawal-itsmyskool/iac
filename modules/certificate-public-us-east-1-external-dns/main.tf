# us-east-1 public ACM certificate validated via an EXTERNAL DNS provider (Cloudflare).
#
# Same as certificate-public-external-dns but pinned to the us-east-1 provider alias,
# for edge-optimized API Gateway custom domains / CloudFront (which require the cert
# in us-east-1). No Route53; you add the validation CNAME(s) at your DNS provider.
#
# Two-phase workflow:
#   1. wait_for_validation = false -> apply -> `terragrunt output validation_records`
#      -> add the CNAME(s) in Cloudflare (DNS-only)
#   2. wait_for_validation = true  -> apply -> blocks until ISSUED

resource "aws_acm_certificate" "cert" {
  provider                  = aws.us-east-1
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "this" {
  count           = var.wait_for_validation ? 1 : 0
  provider        = aws.us-east-1
  certificate_arn = aws_acm_certificate.cert.arn

  timeouts {
    create = var.validation_timeout
  }
}
