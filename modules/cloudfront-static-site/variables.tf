variable "bucket_name" {
  description = "Name of the private S3 bucket that holds the site content"
  type        = string
}

variable "aliases" {
  description = "Custom domain name(s) served by the distribution (e.g. app.dbpasn.itsmyskool.com)"
  type        = list(string)
}

variable "acm_certificate_arn" {
  description = "ARN of a us-east-1 ACM certificate covering the aliases"
  type        = string
}

variable "price_class" {
  description = "CloudFront price class (PriceClass_100 | PriceClass_200 | PriceClass_All)"
  type        = string
  default     = "PriceClass_100"
}

variable "default_root_object" {
  description = "Object served at the root path"
  type        = string
  default     = "index.html"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
