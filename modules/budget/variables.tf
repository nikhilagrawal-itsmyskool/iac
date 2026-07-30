variable "method" {
  description = "method (manual or iac) to deploy a resource"
}

variable "stage" {
  description = "stage of the deployment (dev, prod etc)"
}

variable "prefix" {
  description = "prefix for the resources"
}

variable "limit_amount" {
  description = "Monthly budget limit in USD"
  type        = string
  default     = "20"
}

variable "notification_emails" {
  description = "Email addresses that receive budget alerts"
  type        = list(string)
}

variable "actual_thresholds" {
  description = "Percentages of the budget at which to alert on ACTUAL spend"
  type        = list(number)
  default     = [80, 100]
}

variable "forecasted_thresholds" {
  description = "Percentages of the budget at which to alert on FORECASTED spend"
  type        = list(number)
  default     = [100]
}
