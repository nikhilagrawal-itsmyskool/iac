output "app_id" {
  description = "Amplify app id"
  value       = aws_amplify_app.app.id
}

output "default_domain" {
  description = "Amplify-managed default domain (amplifyapp.com)"
  value       = aws_amplify_app.app.default_domain
}

output "app_url" {
  description = "Direct URL of the deployed branch (use to validate before the custom domain is live)"
  value       = "https://${var.branch_name}.${aws_amplify_app.app.default_domain}"
}

output "domain_dns_records" {
  description = "DNS records to add at Cloudflare (DNS-only / grey cloud) to verify + route the custom domain."
  value = var.custom_domain == null ? null : {
    certificate_verification = aws_amplify_domain_association.domain[0].certificate_verification_dns_record
    sub_domains              = aws_amplify_domain_association.domain[0].sub_domain
  }
}
