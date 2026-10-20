output "endpoint" {
  description = "R2 S3 endpoint (set as R2_ENDPOINT in core-api prod.yml)"
  value       = local.r2_endpoint
}

output "bucket" {
  description = "R2 bucket name (set as R2_BUCKET in core-api prod.yml)"
  value       = cloudflare_r2_bucket.bucket.name
}

output "access_key_id_ssm_param" {
  description = "SSM param holding the R2 Access Key ID"
  value       = aws_ssm_parameter.r2_access_key_id.name
}

output "secret_access_key_ssm_param" {
  description = "SSM param (SecureString) holding the R2 Secret Access Key"
  value       = aws_ssm_parameter.r2_secret_access_key.name
}

# Convenience (sensitive) — normally read from SSM, exposed for debugging only.
output "access_key_id" {
  value     = local.r2_access_key_id
  sensitive = true
}

output "secret_access_key" {
  value     = local.r2_secret_access_key
  sensitive = true
}

output "bucket_scope_resource" {
  description = "The token's single-bucket resource key (for auditing the scope)"
  value       = "com.cloudflare.edge.r2.bucket.${var.cloudflare_account_id}_${var.jurisdiction}_${cloudflare_r2_bucket.bucket.name}"
}
