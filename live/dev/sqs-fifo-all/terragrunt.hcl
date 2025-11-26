terraform {
  source = "../../../modules//sqs-fifo"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  dev_config = read_terragrunt_config("../root.hcl")
  visibility_timeout_seconds = 30
  message_retention_seconds = 4*24*60*60
  delay_seconds = 0
  max_message_size_bytes = 256*1024
  receive_wait_time_seconds = 0
  sqs_managed_sse_enabled = false
}

inputs = merge(
  local.dev_config.inputs,
  {
    queue_details = [
        {
          queue_name = "${local.dev_config.inputs.stage}_${local.dev_config.inputs.prefix}_sample.fifo", 
          visibility_timeout_seconds = 5*60
          message_retention_seconds = local.message_retention_seconds
          delay_seconds = local.delay_seconds
          max_message_size_bytes = local.max_message_size_bytes
          receive_wait_time_seconds = local.receive_wait_time_seconds
          sqs_managed_sse_enabled = local.sqs_managed_sse_enabled
        }
      ]
    tags = {
        Name = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.method}-${local.dev_config.inputs.prefix}-sqs-fifo"
    }        
  }
)