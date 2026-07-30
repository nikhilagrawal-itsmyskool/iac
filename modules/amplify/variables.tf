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

variable "app_name" {
  description = "Amplify app name"
  type        = string
}

variable "repository" {
  description = "Git repository URL (e.g. https://github.com/org/admin-portal)"
  type        = string
}

variable "access_token" {
  description = "Personal access token for the git provider (GitHub PAT). Pass via env, do not commit."
  type        = string
  sensitive   = true
}

variable "build_spec" {
  description = "Amplify build spec (YAML). If empty, Amplify auto-detects."
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "App-level build environment variables"
  type        = map(string)
  default     = {}
}

variable "branch_environment_variables" {
  description = "Branch-level environment variables (override app-level)"
  type        = map(string)
  default     = {}
}

variable "branch_name" {
  description = "Git branch Amplify builds and deploys"
  type        = string
  default     = "main"
}

variable "branch_stage" {
  description = "Amplify branch stage"
  type        = string
  default     = "PRODUCTION"
}

variable "custom_domain" {
  description = "Apex/root domain for the custom domain association (e.g. itsmyskool.com). Null to skip."
  type        = string
  default     = null
}

variable "subdomain_prefix" {
  description = "Subdomain prefix under custom_domain (e.g. dbpasn-prod). Use \"\" for the apex."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
