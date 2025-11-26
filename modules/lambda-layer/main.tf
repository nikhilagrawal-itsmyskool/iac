# S3 bucket for storing Lambda layer zip files
resource "aws_s3_bucket" "layer_bucket" {
  count  = var.create_bucket ? 1 : 0
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "layer_bucket_versioning" {
  count  = var.create_bucket && var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.layer_bucket[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "layer_bucket_encryption" {
  count  = var.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.layer_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Upload layer zip file to S3
resource "aws_s3_object" "layer_zip" {
  bucket = var.create_bucket ? aws_s3_bucket.layer_bucket[0].id : var.bucket_name
  key    = "${var.layer_name}/${var.layer_version}/${basename(var.layer_zip_path)}"
  source = var.layer_zip_path
  etag   = filemd5(var.layer_zip_path)

  tags = var.tags
}

# Lambda Layer
resource "aws_lambda_layer_version" "layer" {
  layer_name          = var.layer_name
  description         = var.description
  compatible_runtimes = var.compatible_runtimes

  s3_bucket  = var.create_bucket ? aws_s3_bucket.layer_bucket[0].id : var.bucket_name
  s3_key     = aws_s3_object.layer_zip.key
  s3_object_version = var.enable_versioning ? aws_s3_object.layer_zip.version_id : null

  skip_destroy = var.skip_destroy

  depends_on = [aws_s3_object.layer_zip]
}

