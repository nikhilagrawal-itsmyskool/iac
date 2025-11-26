variable "method" {
  description = "method (manual or iac) to deploy a resource"
}

variable "stage" {
  description = "stage of the deployment (dev, prod etc)"
}

variable "prefix" {
  description = "prefix for the resources"
}

variable "queue_details" {
  type = list(object({
    queue_name = string
    visibility_timeout_seconds = number
    message_retention_seconds = number
    delay_seconds = number
    max_message_size_bytes = number
    receive_wait_time_seconds = number
    sqs_managed_sse_enabled = bool
  }))
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}