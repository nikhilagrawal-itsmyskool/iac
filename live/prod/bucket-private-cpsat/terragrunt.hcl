terraform {
  source = "../../../modules//bucket-private"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

# Private bucket for CP-SAT timetable run artifacts, keyed by runs/<runId>/.
# For now holds the rendered exports (timetable.pdf / timetable.xlsx) that the local
# solver poller produces, so the prod getRunExport Lambda can serve them (the prod
# Lambda has no access to the local disk where they're rendered). Later this is where
# the full fs->S3 artifact seam (solution.json, solver-input.json, ...) can move.
inputs = merge(
  local.prod_config.inputs,
  {
    bucket_names = [
      {
        bucket_name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.prefix}-cpsat"
      }
    ]
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-cpsat"
    }
  }
)
