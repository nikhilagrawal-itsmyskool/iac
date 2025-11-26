resource "aws_s3_bucket" "private_bucket" {

  for_each = { for o in var.bucket_names : o.bucket_name => o }

  bucket = each.value.bucket_name

  tags = var.tags

}

resource "aws_s3_bucket_accelerate_configuration" "private_bucket_accelerate_configuration" {

  for_each = { for o in var.bucket_names : o.bucket_name => o }

  bucket = aws_s3_bucket.private_bucket[each.key].id
  status = "Enabled"
}