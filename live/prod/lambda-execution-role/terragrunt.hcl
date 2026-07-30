terraform {
  source = "../../../modules//lambda-execution-role"
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
    account_id = "264318271546"
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-lambda-execution"
    }
  }
)
