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

variable "domain_name" {
  description = "Primary domain name for the certificate (e.g. api-prod.itsmyskool.com)"
  type        = string
}

variable "subject_alternative_names" {
  description = "List of subject alternative names for the certificate"
  type        = list(string)
  default     = []
}

variable "wait_for_validation" {
  description = "When true, block until ACM reports the cert ISSUED. Enable on a second apply after adding the validation CNAME(s) at your DNS provider."
  type        = bool
  default     = false
}

variable "validation_timeout" {
  description = "How long to wait for validation when wait_for_validation is true"
  type        = string
  default     = "45m"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
