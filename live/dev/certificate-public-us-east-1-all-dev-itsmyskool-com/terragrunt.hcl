terraform {
  source = "../../../modules//certificate-public-us-east-1"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  dev_config = read_terragrunt_config("../root.hcl")
}

inputs = merge(
  local.dev_config.inputs,
  {
    domain_name = "*.${local.dev_config.inputs.domain}"
    tags = {
      Name = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.method}-${local.dev_config.inputs.prefix}-all-dev-itsmyskool-com"
    }    
  }
)