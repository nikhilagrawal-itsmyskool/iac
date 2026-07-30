generate "versions" {
  path      = "versions_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
        aws = {
          version = "~> 5.0"
          source = "hashicorp/aws"
        }
      }
    }
EOF
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    provider "aws" {
      region = "ap-south-1"
      shared_credentials_files = ["/home/nikhil/.aws/credentials"]
      profile = "prod-itsmyskool-nikhil.agrawal"
    }
    provider "aws" {
      alias = "us-east-1"
      region = "us-east-1"
      shared_credentials_files = ["/home/nikhil/.aws/credentials"]
      profile = "prod-itsmyskool-nikhil.agrawal"
    }
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "264318271546-itsmyskool-terraform-state"
    key = "prod/${path_relative_to_include()}/terraform.tfstate"
    encrypt = true
    dynamodb_table = "itsmyskool-lock-table"
    region = "ap-south-1"
    shared_credentials_file = "/home/nikhil/.aws/credentials"
    profile = "prod-itsmyskool-nikhil.agrawal"
  }
}

inputs = {
  region = "ap-south-1"
  method = "iac"
  stage = "prod"
  prefix = "itsmyskool"
  domain = "itsmyskool.com"
  hosted_zone = "itsmyskool.com"
  cdn_price_class = "PriceClass_All"
}
