resource "aws_key_pair" "aws_key" {
  key_name   = "${var.stage}-${var.method}-${var.prefix}-${var.key_name}"
  public_key = file(var.public_key_path)
}