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
      shared_credentials_files = ["/home/smita/.aws/credentials"]
      profile = "dev-itsmyskool-nikhil.agrawal"
    }
    provider "aws" {
      alias = "us-east-1"
      region = "us-east-1"
      shared_credentials_files = ["/home/smita/.aws/credentials"]
      profile = "dev-itsmyskool-nikhil.agrawal"
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
    bucket = "091927605421-itsmyskool-terraform-state"
    key = "dev/${path_relative_to_include()}/terraform.tfstate"
    encrypt = true
    dynamodb_table = "itsmyskool-lock-table"
    region = "ap-south-1"
    shared_credentials_file = "/home/smita/.aws/credentials"
    profile = "dev-itsmyskool-nikhil.agrawal"    
  }
}

inputs = {
  region = "ap-south-1"
  method = "iac"
  stage = "dev"
  prefix = "itsmyskool"
  domain = "dev.itsmyskool.com"
  hosted_zone = "itsmyskool.com"
  cdn_price_class = "PriceClass_All"  
}
