# Cloudflare R2 bucket + a BUCKET-SCOPED S3-API token, with the secret surfaced to the app
# via SSM.
#
# R2 is S3-compatible but the cloudflare provider has no first-class "R2 access key" resource.
# The documented pattern derives S3 creds from an account token scoped to this one bucket:
#   Access Key ID     = cloudflare_account_token.<t>.id
#   Secret Access Key = sha256(cloudflare_account_token.<t>.value)   # SHA-256 HEX of the value
# Scope: the "Workers R2 Storage Bucket Item Write" permission group (object read/write/list)
# on ONLY this bucket's resource — the token cannot touch other buckets, DNS, or mint tokens.
#
# The aws provider (default, ap-south-1) comes from the shared root.hcl generate block; only
# the cloudflare provider is declared here (declaring aws again would be a duplicate).
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

resource "cloudflare_r2_bucket" "bucket" {
  account_id   = var.cloudflare_account_id
  name         = var.bucket_name
  jurisdiction = var.jurisdiction
}

# CORS so a browser can upload LARGE objects (e.g. Moments video) straight to R2 via a
# presigned PUT — without it the browser's preflight blocks the cross-origin request. This is
# bucket config (object-scoped creds can't set it), so it belongs here in IaC next to the
# bucket. Created only when origins are supplied; the GET path (presigned reads) doesn't need
# CORS, so photos were fine without it.
resource "cloudflare_r2_bucket_cors" "bucket" {
  count       = length(var.cors_allowed_origins) > 0 ? 1 : 0
  account_id  = var.cloudflare_account_id
  bucket_name = cloudflare_r2_bucket.bucket.name

  rules = [{
    id = "admin-portal-direct-upload"
    allowed = {
      methods = ["GET", "PUT", "HEAD"]
      origins = var.cors_allowed_origins
      headers = ["*"]
    }
    expose_headers  = ["ETag"]
    max_age_seconds = 3600
  }]
}

# Look up the object read/write permission-group id by name (v5 data source).
data "cloudflare_account_api_token_permission_groups_list" "r2_item_write" {
  account_id = var.cloudflare_account_id
  name       = "Workers%20R2%20Storage%20Bucket%20Item%20Write"
}

# Account-owned token scoped to THIS bucket only.
resource "cloudflare_account_token" "r2" {
  account_id = var.cloudflare_account_id
  name       = "${var.bucket_name}-s3"

  policies = [{
    effect            = "allow"
    permission_groups = [{ id = data.cloudflare_account_api_token_permission_groups_list.r2_item_write.result[0].id }]
    resources = jsonencode({
      "com.cloudflare.edge.r2.bucket.${var.cloudflare_account_id}_${var.jurisdiction}_${cloudflare_r2_bucket.bucket.name}" = "*"
    })
  }]
}

locals {
  r2_endpoint          = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
  r2_access_key_id     = cloudflare_account_token.r2.id
  r2_secret_access_key = sha256(cloudflare_account_token.r2.value)
}

# Surface the S3 creds to core-api via SSM. The shared lambda-execution-role already grants
# ssm:GetParameter on /itsmyskool/prod/* + kms:Decrypt-via-ssm, so no IAM change is needed.
resource "aws_ssm_parameter" "r2_access_key_id" {
  name  = "/${var.prefix}/${var.stage}/r2/access_key_id"
  type  = "String"
  value = local.r2_access_key_id
  tags  = var.tags
}

resource "aws_ssm_parameter" "r2_secret_access_key" {
  name  = "/${var.prefix}/${var.stage}/r2/secret_access_key"
  type  = "SecureString"
  value = local.r2_secret_access_key
  tags  = var.tags
}
