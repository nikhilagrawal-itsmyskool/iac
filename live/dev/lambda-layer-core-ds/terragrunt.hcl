terraform {
  source = "../../../modules//bucket-private"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  dev_config = read_terragrunt_config("../root.hcl")
}

inputs = merge(
  local.dev_config.inputs,
  {
    layer_name     = "${local.dev_config.inputs.stage}-core-ds"
    layer_zip_path = "${get_terragrunt_dir()}/my-layer.zip"
    layer_version  = "v1.0.0"

    bucket_name    = "${local.dev_config.inputs.stage}-lambda-layers"
    create_bucket  = true
    enable_versioning = false
    
    compatible_runtimes = ["python3.9", "python3.10", "python3.11", "python3.12"]
    description         = "Custom Python layer for Lambda functions"

    tags = {
        Name = "${stage}-${}-lambda-layer-core-ds"
    }

  }
)    



