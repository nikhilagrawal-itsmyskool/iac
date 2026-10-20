output "bucket" {
  description = "Name of the private content bucket (upload via: aws s3 cp ... s3://<bucket>/)"
  value       = aws_s3_bucket.site.id
}

output "bucket_arn" {
  value = aws_s3_bucket.site.arn
}

output "distribution_id" {
  description = "CloudFront distribution id (for invalidations)"
  value       = aws_cloudfront_distribution.site.id
}

output "distribution_domain_name" {
  description = "CloudFront domain — CNAME your custom domain here in Cloudflare (DNS-only)"
  value       = aws_cloudfront_distribution.site.domain_name
}
