variable "cloudflare_account_id" {
  description = "Cloudflare account id that owns the Worker script"
  type        = string
}

variable "zone_id" {
  description = "Cloudflare zone id for itsmyskool.com (holds the DNS record + Worker route)"
  type        = string
}

variable "worker_name" {
  description = "Name of the Cloudflare Worker script"
  type        = string
  default     = "biometric-iclock-proxy"
}

variable "record_name" {
  description = "Hostname the biometric device hits (proxied CNAME + Worker route)"
  type        = string
  default     = "biometric.itsmyskool.com"
}

variable "origin_host" {
  description = "HTTPS origin the Worker forwards to (prod API Gateway custom domain)"
  type        = string
  default     = "api-prod.itsmyskool.com"
}

variable "tags" {
  description = "Optional tags (unused by Cloudflare resources; kept for convention/parity)"
  type        = map(string)
  default     = {}
}
