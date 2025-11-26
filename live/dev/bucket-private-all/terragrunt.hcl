terraform {
  source = "../../../modules//bucket-private"
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
    bucket_names = [
        {
          bucket_name = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.prefix}-sample", 
        }
    ]
    tags = {
      Name = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.method}-${local.dev_config.inputs.prefix}-bucket-private"
    }    
  }
)