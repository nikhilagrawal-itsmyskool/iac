variable "stage" {
  description = "stage of the deployment (dev, prod etc)"
}

variable "prefix" {
  description = "prefix for the resources (SSM param path is /<prefix>/<stage>/r2/*)"
}

variable "cloudflare_account_id" {
  description = "Cloudflare account id that owns the R2 bucket (also the S3 endpoint host)"
}

variable "bucket_name" {
  description = "R2 bucket name"
}

variable "jurisdiction" {
  description = "R2 data jurisdiction: default | eu | fedramp. Also part of the bucket-scoped token resource key."
  default     = "default"
}

variable "tags" {
  description = "Tags to apply to the SSM parameters"
  type        = map(string)
  default     = {}
}
