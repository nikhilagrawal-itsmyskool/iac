dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../../modules//security-group"
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
    vpc_id = dependency.network.outputs.vpc_id
    vpc_cidr = dependency.network.outputs.vpc_cidr
    tags = {
      Name = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.method}-${local.dev_config.inputs.prefix}-security-group"
    }    
  }
)