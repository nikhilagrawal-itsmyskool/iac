terraform {
  source = "../../../modules//cloudflare-worker-proxy"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

# Cloudflare provider generated LOCAL to this unit (root.hcl only generates the aws provider).
# The API token is read from the CLOUDFLARE_API_TOKEN env var at apply time (never committed),
# same convention as the cloudflare-r2-moments unit. The aws provider still comes from root.hcl.
generate "cloudflare_provider" {
  path      = "cloudflare_provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "cloudflare" {}
EOF
}

# Cloudflare Worker bridging the HTTP-only biometric device to the HTTPS prod API
# (biometric.itsmyskool.com -> rewrites /iclock/* to /biometric/* -> api-prod.itsmyskool.com).
#
# Apply with ALL of these exported (see module readme for token scopes):
#   export CLOUDFLARE_API_TOKEN=<token: Workers Scripts:Edit + Workers Routes:Edit + DNS:Edit>
#   export CLOUDFLARE_ACCOUNT_ID=<cloudflare account id>
#   export CLOUDFLARE_ZONE_ID=<itsmyskool.com zone id>
#   export AWS_PROFILE=prod-itsmyskool-nikhil.agrawal
#   terragrunt apply
inputs = merge(
  local.prod_config.inputs,
  {
    cloudflare_account_id = get_env("CLOUDFLARE_ACCOUNT_ID", "")
    zone_id               = get_env("CLOUDFLARE_ZONE_ID", "")
    worker_name           = "biometric-iclock-proxy"
    record_name           = "biometric.itsmyskool.com"
    origin_host           = "api-prod.itsmyskool.com"
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-biometric-proxy"
    }
  }
)
