output "layer_arn" {
  description = "ARN of the Lambda layer version"
  value       = aws_lambda_layer_version.layer.arn
}

output "layer_version" {
  description = "Version number of the Lambda layer"
  value       = aws_lambda_layer_version.layer.version
}

output "layer_version_arn" {
  description = "ARN of the specific layer version"
  value       = aws_lambda_layer_version.layer.layer_arn
}

output "created_date" {
  description = "Date the layer version was created"
  value       = aws_lambda_layer_version.layer.created_date
}

output "s3_bucket_id" {
  description = "ID of the S3 bucket storing the layer zip"
  value       = var.create_bucket ? aws_s3_bucket.layer_bucket[0].id : var.bucket_name
}

output "s3_object_key" {
  description = "S3 key of the uploaded layer zip file"
  value       = aws_s3_object.layer_zip.key
}

output "s3_object_version_id" {
  description = "Version ID of the S3 object (if versioning is enabled)"
  value       = var.enable_versioning ? aws_s3_object.layer_zip.version_id : null
}

