dependency "network" {
  config_path = "../network"
}

dependency "security_group" {
  config_path = "../security-group"
}

terraform {
  source = "../../../modules//postgresql"
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
    vpc_id             = dependency.network.outputs.vpc_id
    use_public_subnet = true
    public_subnet_id_1 = dependency.network.outputs.public_subnet_id_1
    public_subnet_id_2 = dependency.network.outputs.public_subnet_id_2
    security_group_ids = [
      dependency.security_group.outputs.sg_allow_postgresql_from_all_id
    ]

    instance_class = "db.t3.micro"
    identifier = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.method}-${local.dev_config.inputs.prefix}-postgresql-public"

    db_name     = "itsmyskool"
    db_username = "root"
    db_password = "itsmyskool123"

    tags = {
      Name = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.method}-${local.dev_config.inputs.prefix}-postgresql-public"
    }
  }
)