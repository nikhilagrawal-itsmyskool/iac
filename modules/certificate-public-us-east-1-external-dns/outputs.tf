output "certificate_arn" {
  description = "ARN of the ACM certificate (us-east-1)"
  value       = aws_acm_certificate.cert.arn
}

output "certificate_domain" {
  description = "Primary domain of the certificate"
  value       = aws_acm_certificate.cert.domain_name
}

output "validation_records" {
  description = "Add these CNAME records at your DNS provider (Cloudflare, DNS-only / grey cloud) to validate the certificate."
  value = [
    for dvo in aws_acm_certificate.cert.domain_validation_options : {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  ]
}
