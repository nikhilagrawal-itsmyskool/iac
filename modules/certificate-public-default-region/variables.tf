variable "method" {
  description = "method (manual or iac) to deploy a resource"
}

variable "stage" {
  description = "stage of the deployment (dev, prod etc)"
}

variable "prefix" {
  description = "prefix for the resources"
}

variable "domain_name" {
  description = "domain name for certificate"
}

variable "hosted_zone" {
  description = "hosted zone"
}

variable "subject_alternative_names" {
  description = "List of subject alternative names for the certificate"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}