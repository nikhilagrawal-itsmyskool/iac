variable "method" {
  description = "method (manual or iac) to deploy a resource"
}

variable "stage" {
  description = "stage of the deployment (dev, prod etc)"
}

variable "prefix" {
  description = "prefix for the resources"
}

variable "key_name" {
  default = "aws-key"
}

variable "public_key_path" {
  default = "aws-key.pub"
}