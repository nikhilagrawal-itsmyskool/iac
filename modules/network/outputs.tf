output "vpc_id" {
  description = "vpc id"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr" {
  description = "main cidr block vpc"
  value       = var.vpc_cidr
}
  
output "public_subnet_id_1" {
  description = "public subnet id"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_id_2" {
  description = "public subnet id"
  value       = aws_subnet.public_subnet_2.id
}
  
output "private_subnet_id_1" {
  description = "private subnet id"
  value       = aws_subnet.private_subnet_1.id
}
  
output "private_subnet_id_2" {
  description = "private subnet id"
  value       = aws_subnet.private_subnet_2.id
}
  
output "private_subnet_id_3" {
  description = "private subnet id"
  value       = aws_subnet.private_subnet_3.id
}

#output "nat_gateway_ip" {
#  description = "elastic ip attached to NAT gateway"
#  value       = aws_eip.nat_gateway_eip.public_ip
#}
  