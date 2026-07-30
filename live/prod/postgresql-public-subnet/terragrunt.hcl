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
  prod_config = read_terragrunt_config("../root.hcl")
}

inputs = merge(
  local.prod_config.inputs,
  {
    vpc_id             = dependency.network.outputs.vpc_id
    use_public_subnet  = true
    public_subnet_id_1 = dependency.network.outputs.public_subnet_id_1
    public_subnet_id_2 = dependency.network.outputs.public_subnet_id_2
    security_group_ids = [
      dependency.security_group.outputs.sg_allow_postgresql_from_all_id
    ]

    # Match the local PG18 client tools used for the dump/restore
    engine_version = "18.4"

    # Graviton (ARM) burstable, smallest tier
    instance_class = "db.t4g.micro"
    identifier     = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-postgresql-public"

    db_name     = "itsmyskool_prod"
    db_username = "postgres"
    db_password = "DCmBQd9aHVXOxNGJwzLvCXfUKWoc"

    tags = {
      Name = "${local.prod_config.inputs.stage}-${local.prod_config.inputs.method}-${local.prod_config.inputs.prefix}-postgresql-public"
    }
  }
)
