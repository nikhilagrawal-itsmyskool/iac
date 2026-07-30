# Public ACM certificate validated via an EXTERNAL DNS provider (e.g. Cloudflare).
#
# Unlike modules/certificate-public-default-region, this does NOT look up a Route53
# hosted zone or create validation records. It emits the CNAME(s) you must add at your
# DNS provider (see the `validation_records` output) and, once `wait_for_validation`
# is set, blocks until ACM observes them and marks the cert ISSUED.
#
# Two-phase workflow with Cloudflare:
#   1. apply with wait_for_validation = false  -> cert created (PENDING_VALIDATION)
#      `terragrunt output validation_records`  -> add the CNAME(s) in Cloudflare (DNS-only)
#   2. set wait_for_validation = true, apply    -> waits until ISSUED

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# No validation_record_fqdns: ACM is validated out-of-band (external DNS), so this
# resource simply polls until the certificate reports ISSUED.
resource "aws_acm_certificate_validation" "this" {
  count           = var.wait_for_validation ? 1 : 0
  certificate_arn = aws_acm_certificate.cert.arn

  timeouts {
    create = var.validation_timeout
  }
}
