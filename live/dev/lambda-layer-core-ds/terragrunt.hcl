terraform {
  source = "../../../modules//lambda-layer"
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
    layer_name     = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.prefix}-core-ds"
    layer_zip_path = "${get_terragrunt_dir()}/ds-layer-1764386920.zip"
    layer_version  = "v1.0.3"

    bucket_name    = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.prefix}-lambda-layer"
    create_bucket  = true
    enable_versioning = true
    
    compatible_runtimes = ["python3.9", "python3.10", "python3.11"]
    description         = "Custom Python layer for Lambda functions"

    tags = {
        Name = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.method}-${local.dev_config.inputs.prefix}-lambda-layer-core-ds"
    }

  }
)    



