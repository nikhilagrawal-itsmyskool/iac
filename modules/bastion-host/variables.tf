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

variable "ami" {
  description = "ami for bastion host ec2 instance"
}

variable "instance_type" {
  description = "bastion type for our bastion ec2"
}

variable "volume_size" {
  description = "bastion ec2 instance volume size"
}

variable "volume_type" {
  description = "bastion ec2 instance volume type"
}

variable "public_security_group_id" {
  description = "security group for our bastion ec2 instance"
}

variable "public_subnet_id" {
  description = "public subnet id to release our bastion ec2 instance"
}

variable "aws_key_id" {
  default = "aws_key_id"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}