variable "method" {
  description = "method (manual or iac) to deploy a resource"
  default     = "iac"
}

variable "stage" {
  description = "stage of the deployment (dev, prod etc)"
  default     = "prod"
}

variable "prefix" {
  description = "prefix for the resources"
  default     = "itsmyskool"
}

variable "region" {
  description = "AWS region (used to scope the CloudWatch Logs resource)"
  type        = string
}

variable "account_id" {
  description = "AWS account id (used to scope the CloudWatch Logs resource)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
