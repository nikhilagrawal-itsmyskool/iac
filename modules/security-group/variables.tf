variable "method" {
  description = "method (manual or iac) to deploy a resource"
}

variable "stage" {
  description = "stage of the deployment (dev, prod etc)"
}

variable "prefix" {
  description = "prefix for the resources"
}

variable "suffix" {
  description = "suffix for the resources"
  default     = ""
}

variable "vpc_id" {
  description = "ami for bastion host ec2 instance"
}

variable "vpc_cidr" {
  description = "main cidr block for dev-pcd vpc"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}