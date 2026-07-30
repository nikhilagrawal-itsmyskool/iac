terraform {
  source = "../../../modules//budget"
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
    limit_amount = "20"
    notification_emails = [
      "nikhil.pa@gmail.com",
    ]
    actual_thresholds     = [80, 100]
    forecasted_thresholds = [100]
  }
)
