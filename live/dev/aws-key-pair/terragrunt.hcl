terraform {
  source = "../../../modules//aws-key-pair"
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
    key_name = "aws-key"
    public_key_path = "aws-key.pub"
  }
)