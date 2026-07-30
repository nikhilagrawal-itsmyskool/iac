terraform {
  source = "../../../modules//amplify"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prod_config = read_terragrunt_config("../root.hcl")
}

# admin-portal (Vite/React SPA) on Amplify Hosting, git-connected to the main branch.
#
# GitHub PAT is read from the environment (never committed):
#   export AMPLIFY_GITHUB_TOKEN=ghp_xxx   (needs repo + admin:repo_hook scopes)
#
# The build overwrites .env.production so the SPA points at the prod API (api-prod),
# not the live api.itsmyskool.com baked into the committed .env.production.
inputs = merge(
  local.prod_config.inputs,
  {
    app_name     = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.prefix}-admin-portal"
    repository   = "https://github.com/nikhilagrawal-itsmyskool/admin-portal"
    access_token = get_env("AMPLIFY_GITHUB_TOKEN", "")

    branch_name  = "main"
    branch_stage = "PRODUCTION"

    custom_domain    = local.prod_config.inputs.hosted_zone # itsmyskool.com
    subdomain_prefix = "*"                                  # wildcard: every <school>.itsmyskool.com routes here

    environment_variables = {
      VITE_API_BASE_URL = "https://api-prod.itsmyskool.com"
      # No VITE_SCHOOL_CODE: getSchoolCode() derives it at runtime from the leftmost
      # hostname label (src/config/api.js), so it must NOT be baked in at build time.
    }

    build_spec = <<-EOT
      version: 1
      frontend:
        phases:
          preBuild:
            commands:
              - npm ci
              - 'echo "VITE_API_BASE_URL=$VITE_API_BASE_URL" > .env.production'
              - 'echo "VITE_SCHOOL_CODE=$VITE_SCHOOL_CODE" >> .env.production'
          build:
            commands:
              - npm run build:prod
        artifacts:
          baseDirectory: dist
          files:
            - '**/*'
        cache:
          paths:
            - node_modules/**/*
    EOT

    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-admin-portal"
    }
  }
)
