output "worker_name" {
  description = "Deployed Cloudflare Worker script name"
  value       = cloudflare_workers_script.proxy.script_name
}

output "route_pattern" {
  description = "Worker route pattern (hostname the device hits)"
  value       = cloudflare_workers_route.proxy.pattern
}

output "record_name" {
  description = "Proxied DNS record fronting the Worker"
  value       = cloudflare_dns_record.proxy.name
}

output "origin_host" {
  description = "HTTPS origin the Worker forwards requests to"
  value       = var.origin_host
}
