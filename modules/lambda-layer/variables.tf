variable "layer_name" {
  description = "Name of the Lambda layer"
  type        = string
}

variable "layer_zip_path" {
  description = "Local path to the layer zip file"
  type        = string
}

variable "layer_version" {
  description = "Version identifier for the layer (used in S3 key path)"
  type        = string
  default     = "v1.0.0"
}

variable "description" {
  description = "Description of the Lambda layer"
  type        = string
  default     = ""
}

variable "compatible_runtimes" {
  description = "List of compatible runtime versions for the layer"
  type        = list(string)
  default     = ["python3.9", "python3.10", "python3.11", "python3.12"]
}

variable "bucket_name" {
  description = "Name of the S3 bucket to store the layer zip. If create_bucket is true, this will be the new bucket name."
  type        = string
}

variable "create_bucket" {
  description = "Whether to create a new S3 bucket or use an existing one"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable versioning on the S3 bucket (only applies if create_bucket is true)"
  type        = bool
  default     = false
}

variable "skip_destroy" {
  description = "Whether to skip destroying the layer version when the resource is destroyed"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

