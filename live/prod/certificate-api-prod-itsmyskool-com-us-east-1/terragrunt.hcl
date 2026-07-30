terraform {
  source = "../../../modules//certificate-public-us-east-1-external-dns"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

# us-east-1 cert for the EDGE-optimized API Gateway custom domain api-prod.itsmyskool.com
# (serverless-domain-manager creates an edge domain, which requires the cert in us-east-1).
# DNS is on Cloudflare -> validate out-of-band:
#   1. wait_for_validation = false -> apply -> `terragrunt output validation_records`
#      -> add the CNAME in Cloudflare (DNS-only). NOTE: this is likely the SAME record
#         you already added for the ap-south-1 cert, so it may already be present.
#   2. flip wait_for_validation = true -> apply (blocks until ISSUED)
inputs = merge(
  local.prod_config.inputs,
  {
    domain_name         = "api-prod.itsmyskool.com"
    wait_for_validation = true
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-api-prod-itsmyskool-com-us-east-1"
    }
  }
)
