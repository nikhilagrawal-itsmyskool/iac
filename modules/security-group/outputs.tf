output "sg_allow_ssh_from_bastion_id" {
  description = "security group id to allow ssh traffic from bastion to private network"
  value       = aws_security_group.allow_ssh_from_bastion.id
}

output "sg_allow_ssh_from_all_id" {
  description = "security group id to allow ssh traffic to bastion"
  value       = aws_security_group.allow_ssh_from_all.id
}

output "sg_allow_ssh_http_from_all_id" {
  description = "security group id to allow all ssh and http traffic to nginx"
  value       = aws_security_group.allow_ssh_http_from_all.id
}

output "sg_allow_mysql_from_bastion_id" {
  description = "security group id to allow MySQL access from bastion host"
  value       = aws_security_group.allow_mysql_from_bastion.id
}

output "sg_allow_mysql_from_lambda_id" {
  description = "security group id to allow MySQL/Aurora access from Lambda function"
  value       = aws_security_group.allow_mysql_from_lambda.id
}

output "sg_lambda_rds_access_id" {
  description = "security group id for Lambda function that needs RDS access"
  value       = aws_security_group.lambda_rds_access.id
}

output "sg_allow_postgresql_from_bastion_id" {
  description = "security group id to allow PostgreSQL access from bastion host"
  value       = aws_security_group.allow_postgresql_from_bastion.id
}

output "sg_allow_postgresql_from_lambda_id" {
  description = "security group id to allow PostgreSQL access from Lambda function"
  value       = aws_security_group.allow_postgresql_from_lambda.id
}

output "sg_allow_postgresql_from_all_id" {
  description = "security group id to allow PostgreSQL access from all (use for public subnet databases)"
  value       = aws_security_group.allow_postgresql_from_all.id
}
