terraform {
  source = "../../../modules//sns-fifo-subscription"
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
    subscription_details = [
        {
          topic_name = "${local.dev_config.inputs.stage}_${local.dev_config.inputs.prefix}_sample.fifo", 
          queue_name = "${local.dev_config.inputs.stage}_${local.dev_config.inputs.prefix}_sample.fifo" 
        }
    ]
    tags = {
        Name = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.method}-${local.dev_config.inputs.prefix}-sns-fifo-subscription"
    }        
  }
)