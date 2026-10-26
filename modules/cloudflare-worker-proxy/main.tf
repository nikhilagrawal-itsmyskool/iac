# Cloudflare Worker that bridges an HTTP-only biometric device to our HTTPS prod API.
#
# The biometric device speaks plain HTTP to a fixed root path (/iclock/...). Our prod API
# Gateway serves the same handlers under /biometric and is HTTPS-only. This unit stands up a
# proxied DNS record (biometric.itsmyskool.com) that Cloudflare terminates, runs a Worker on
# that hostname which rewrites /iclock/* -> /biometric/* and forwards to the prod API custom
# domain over HTTPS. The device therefore talks HTTP to Cloudflare's edge; Cloudflare talks
# HTTPS to our origin.
#
# Cloudflare provider v5 (schema differs a lot from v4). Only the cloudflare provider is
# declared here — the aws provider (default, ap-south-1) comes from the shared root.hcl
# generate block, and this unit creates no AWS resources.
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

# The Worker itself. Service-worker syntax (no main_module) so we avoid the ES-module schema.
# content_type pins the classic service-worker MIME; main_module is deliberately left unset.
resource "cloudflare_workers_script" "proxy" {
  account_id   = var.cloudflare_account_id
  script_name  = var.worker_name
  content      = file("${path.module}/worker.js")
  content_type = "application/javascript"
}

# Bind the Worker to every request on the proxied hostname.
resource "cloudflare_workers_route" "proxy" {
  zone_id = var.zone_id
  pattern = "${var.record_name}/*"
  script  = cloudflare_workers_script.proxy.script_name
}

# Proxied (orange-cloud) CNAME so Cloudflare terminates the device's HTTP request at the edge
# and the Worker route above intercepts it. content points at the prod API custom domain; the
# Worker overrides the hostname anyway, but a valid, resolvable origin is required for the
# proxied record. ttl=1 means "auto" (required by Cloudflare when proxied=true).
resource "cloudflare_dns_record" "proxy" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = "CNAME"
  content = var.origin_host
  proxied = true
  ttl     = 1
}
