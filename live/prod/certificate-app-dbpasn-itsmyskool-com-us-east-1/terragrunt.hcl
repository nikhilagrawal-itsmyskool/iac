terraform {
  source = "../../../modules//certificate-public-us-east-1-external-dns"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

# us-east-1 ACM cert for the parent-app install page app.dbpasn.itsmyskool.com, consumed by
# the CloudFront distribution (cloudfront-dbpasn-app). DNS is on Cloudflare -> validate
# out-of-band:
#   1. wait_for_validation = false -> apply -> `terragrunt output validation_records`
#      -> add the CNAME in Cloudflare (DNS-only / grey cloud); keep it for auto-renewal.
#   2. flip wait_for_validation = true -> apply (blocks until ISSUED).
inputs = merge(
  local.prod_config.inputs,
  {
    domain_name         = "app.dbpasn.itsmyskool.com"
    wait_for_validation = true
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-app-dbpasn-itsmyskool-com-us-east-1"
    }
  }
)
