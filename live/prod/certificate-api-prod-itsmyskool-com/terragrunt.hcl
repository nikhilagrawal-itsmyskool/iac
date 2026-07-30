terraform {
  source = "../../../modules//certificate-public-external-dns"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

# ap-south-1 regional cert for the API Gateway custom domain api-prod.itsmyskool.com.
# DNS lives on Cloudflare, so validation is out-of-band:
#   1. wait_for_validation = false -> apply -> `terragrunt output validation_records`
#      -> add the CNAME(s) in Cloudflare as DNS-only (grey cloud)
#   2. flip wait_for_validation = true -> apply (blocks until ISSUED)
inputs = merge(
  local.prod_config.inputs,
  {
    domain_name         = "api-prod.itsmyskool.com"
    wait_for_validation = true
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-api-prod-itsmyskool-com"
    }
  }
)
