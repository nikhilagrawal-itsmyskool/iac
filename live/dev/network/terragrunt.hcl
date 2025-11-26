terraform {
  source = "../../../modules//network"
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
    vpc_cidr = "10.10.20.0/24"
    newbits = 3
    tags = {
      Name = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.method}-${local.dev_config.inputs.prefix}-network"
    }
  }
)