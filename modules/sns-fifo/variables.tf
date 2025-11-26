variable "method" {
  description = "method (manual or iac) to deploy a resource"
}

variable "stage" {
  description = "stage of the deployment (dev, prod etc)"
}

variable "prefix" {
  description = "prefix for the resources"
}

variable "topic_details" {
  type = list(object({
    topic_name = string
  }))
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}