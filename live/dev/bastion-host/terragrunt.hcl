dependency "network" {
  config_path = "../network"
}

dependency "security_group" {
  config_path = "../security-group"
}

dependency "aws_key_pair" {
  config_path = "../aws-key-pair"
}


terraform {
  source = "../../../modules//bastion-host"
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
    ami           = "ami-0e0ff68cb8e9a188a"
    instance_type = "t3a.nano"
    volume_size  = 8
    volume_type  = "gp2"
    public_subnet_id = dependency.network.outputs.public_subnet_id_1
    public_security_group_id = dependency.security_group.outputs.sg_allow_ssh_from_all_id
    aws_key_id = dependency.aws_key_pair.outputs.key_id
    tags = {
      Name = "${local.dev_config.inputs.stage}-${local.dev_config.inputs.method}-${local.dev_config.inputs.prefix}-bastion-host"
    }
  }
)