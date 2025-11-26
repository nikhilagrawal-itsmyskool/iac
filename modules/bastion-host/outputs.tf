output "private_dns" {
  value       = aws_instance.bastion_host.private_dns
}

output "public_dns" {
  value       = aws_instance.bastion_host.public_dns
}

output "arn" {
  value       = aws_instance.bastion_host.arn
}