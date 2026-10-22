terraform {
  source = "../../../modules//cloudflare-r2-bucket"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

# The repo's first Cloudflare provider — generated LOCAL to this unit so the AWS-only units
# are unaffected (root.hcl only generates the aws provider + versions). The API token is read
# from the CLOUDFLARE_API_TOKEN env var at apply time (never committed), same convention as
# AMPLIFY_GITHUB_TOKEN. The aws provider still comes from root.hcl's generate block.
generate "cloudflare_provider" {
  path      = "cloudflare_provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "cloudflare" {}
EOF
}

# R2 bucket for parent-facing "Moments" photos (core-api file_storage entity_type='outreach'),
# plus the S3-API credentials written to SSM /itsmyskool/prod/r2/* for core-api to read.
#
# Apply with BOTH env vars exported (see module readme):
#   export CLOUDFLARE_API_TOKEN=<bootstrap token: API Tokens Edit + Workers R2 Storage Edit>
#   export CLOUDFLARE_ACCOUNT_ID=<cloudflare account id>
#   export AWS_PROFILE=prod-itsmyskool-nikhil.agrawal
#   terragrunt apply
inputs = merge(
  local.prod_config.inputs,
  {
    cloudflare_account_id = get_env("CLOUDFLARE_ACCOUNT_ID", "")
    bucket_name           = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.prefix}-moments"
    jurisdiction          = "default"
    # Origins allowed to upload Moments video straight to R2 (presigned PUT). Prod admin portal
    # + local dev. Reads (presigned GET) don't need CORS, so this is upload-only.
    cors_allowed_origins = [
      "https://dbpasn.itsmyskool.com",
      "http://localhost:5173",
    ]
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-moments"
    }
  }
)
