terraform {
  source = "../../../modules//cloudfront-static-site"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

# Private bucket + CloudFront for the SHARED itsmyskool parent-app site (app.itsmyskool.com):
# hosts the shared install page + platform policy pages (school-sites/shared). The cert must
# be ISSUED before this applies. After apply, put the distribution id into
# school-sites/shared/config.json for deploys.
dependency "cert" {
  config_path = "../certificate-app-itsmyskool-com-us-east-1"
  mock_outputs = {
    certificate_arn = "arn:aws:acm:us-east-1:000000000000:certificate/mock-for-plan"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = merge(
  local.prod_config.inputs,
  {
    bucket_name         = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.prefix}-shared-app"
    aliases             = ["app.itsmyskool.com"]
    acm_certificate_arn = dependency.cert.outputs.certificate_arn
    price_class         = local.prod_config.inputs.cdn_price_class
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-shared-app"
    }
  }
)
