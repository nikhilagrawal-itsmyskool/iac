terraform {
  source = "../../../modules//bucket-private"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

# Private bucket that holds file_storage objects (student photos, hiring/fine/uniform
# documents, etc.) after they move out of the Postgres `data` column. Served only via
# the API (getWithData), so it stays fully private. Bucket name is passed to Lambdas as
# FILE_STORAGE_BUCKET in configs/prod/prod.yml.
inputs = merge(
  local.prod_config.inputs,
  {
    bucket_names = [
      {
        bucket_name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.prefix}-file-storage"
      }
    ]
    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-file-storage"
    }
  }
)
