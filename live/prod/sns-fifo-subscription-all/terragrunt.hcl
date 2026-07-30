terraform {
  source = "../../../modules//sns-fifo-subscription"
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
    subscription_details = [
      {
        topic_name = "${local.prod_config.inputs.stage}_${local.prod_config.inputs.prefix}_sample.fifo",
        queue_name = "${local.prod_config.inputs.stage}_${local.prod_config.inputs.prefix}_sample.fifo"
      }
    ]
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-sns-fifo-subscription"
    }
  }
)
