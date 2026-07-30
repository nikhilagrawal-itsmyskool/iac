terraform {
  source = "../../../modules//network"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

inputs = merge(
  local.prod_config.inputs,
  {
    vpc_cidr = "10.20.20.0/24"
    newbits  = 3
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-network"
    }
  }
)
