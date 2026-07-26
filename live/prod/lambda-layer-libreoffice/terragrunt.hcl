terraform {
  source = "../../../modules//lambda-layer"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

# LibreOffice layer for the syllabus model-paper docx -> pdf conversion worker
# (core-api drain-conversions function). Drop the LibreOffice layer zip into this
# directory as `libreoffice-layer.zip` before `terragrunt apply` (e.g. shelf.io's
# aws-lambda-libreoffice release, brotli-packed, self-extracting to /tmp).
# After apply, copy the `layer_arn` output into the drain-conversions function's
# `layers:` in core-api and set SYLLABUS_CONVERT_ENABLED=true.
inputs = merge(
  local.prod_config.inputs,
  {
    layer_name     = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.prefix}-libreoffice"
    layer_zip_path = "${get_terragrunt_dir()}/libreoffice-layer.zip"
    layer_version  = "v1.0.0"

    bucket_name       = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.prefix}-lambda-layer"
    create_bucket     = true
    enable_versioning = true

    compatible_runtimes = ["nodejs20.x", "nodejs22.x"]
    description         = "LibreOffice (headless) for docx -> pdf model-paper conversion"

    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-lambda-layer-libreoffice"
    }
  }
)
