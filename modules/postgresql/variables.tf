variable "method" {
  description = "method (manual or iac) to deploy a resource"
}

variable "stage" {
  description = "stage of the deployment (dev, prod etc)"
}

variable "prefix" {
  description = "prefix for the resources"
}

variable "vpc_id" {
  description = "VPC ID where the database will be deployed"
}

variable "private_subnet_id_1" {
  description = "First private subnet ID for DB subnet group (required if use_public_subnet is false)"
  type        = string
  default     = null
  validation {
    condition = var.private_subnet_id_1 != null || var.use_public_subnet
    error_message = "private_subnet_id_1 is required when use_public_subnet is false."
  }
}

variable "private_subnet_id_2" {
  description = "Second private subnet ID for DB subnet group (required if use_public_subnet is false, must be in different AZ)"
  type        = string
  default     = null
  validation {
    condition = var.private_subnet_id_2 != null || var.use_public_subnet
    error_message = "private_subnet_id_2 is required when use_public_subnet is false."
  }
}

variable "public_subnet_id_1" {
  description = "First public subnet ID for DB subnet group (required if use_public_subnet is true)"
  type        = string
  default     = null
  validation {
    condition = var.public_subnet_id_1 != null || !var.use_public_subnet
    error_message = "public_subnet_id_1 is required when use_public_subnet is true."
  }
}

variable "public_subnet_id_2" {
  description = "Second public subnet ID for DB subnet group (required if use_public_subnet is true, must be in different AZ)"
  type        = string
  default     = null
  validation {
    condition = var.public_subnet_id_2 != null || !var.use_public_subnet
    error_message = "public_subnet_id_2 is required when use_public_subnet is true."
  }
}

variable "use_public_subnet" {
  description = "Flag to indicate if database should be deployed in public subnet (enables publicly_accessible)"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security group IDs for database access"
  type        = list(string)
}

variable "db_name" {
  description = "Name of the database to create"
  default     = "postgres"
}

variable "db_username" {
  description = "Master username for the database"
  default     = "postgres"
}

variable "db_password" {
  description = "Master password for the database"
  sensitive   = true
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  default     = "17.6"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage for autoscaling in GB"
  default     = 100
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  default     = 7
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
}

variable "identifier" {
  type        = string
}