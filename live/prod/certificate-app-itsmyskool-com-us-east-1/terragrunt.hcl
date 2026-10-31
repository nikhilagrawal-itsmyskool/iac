terraform {
  source = "../../../modules//certificate-public-us-east-1-external-dns"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

# us-east-1 ACM cert for the SHARED itsmyskool parent-app site app.itsmyskool.com, consumed by
# the CloudFront distribution (cloudfront-itsmyskool-app). DNS is on Cloudflare -> validate
# out-of-band:
#   1. wait_for_validation = false -> apply -> `terragrunt output validation_records`
#      -> add the CNAME in Cloudflare (DNS-only / grey cloud); keep it for auto-renewal.
#   2. flip wait_for_validation = true -> apply (blocks until ISSUED).
# NOTE: itsmyskool.com's DNS must be on Cloudflare (or wherever you manage it) for this.
inputs = merge(
  local.prod_config.inputs,
  {
    domain_name         = "app.itsmyskool.com"
    wait_for_validation = false
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-app-itsmyskool-com-us-east-1"
    }
  }
)
