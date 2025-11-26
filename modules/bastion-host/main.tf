resource "aws_instance" "bastion_host" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_security_group_id]
  key_name                    = var.aws_key_id
  ebs_block_device {
    #delete_on_termination = (known after apply)
    device_name = "/dev/xvda"
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  tags = var.tags
}