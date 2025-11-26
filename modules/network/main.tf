resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    for key, value in var.tags : key => "${value}-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.newbits, 0)
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    for key, value in var.tags : key => "${value}-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.newbits, 1)
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    for key, value in var.tags : key => "${value}-public-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.newbits, 3)
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    for key, value in var.tags : key => "${value}-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.newbits, 4)
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    for key, value in var.tags : key => "${value}-private-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.newbits, 5)
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    for key, value in var.tags : key => "${value}-private-subnet-3"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    for key, value in var.tags : key => "${value}-internet-gateway"
  }
}

#resource "aws_eip" "nat_gateway_eip" {
#  vpc = true
#  tags = {
#    for key, value in var.tags : key => "${value}-nat-gateway-eip"
#  }
#}

#resource "aws_nat_gateway" "nat_gateway" {
#  allocation_id     = aws_eip.nat_gateway_eip.id
#  connectivity_type = "public"
#  subnet_id         = aws_subnet.public_subnet_1.id
#
#  tags = {
#    for key, value in var.tags : key => "${value}-nat-gateway"
#  }
#
#  # To ensure proper ordering, it is recommended to add an explicit dependency
#  # on the Internet Gateway for the VPC.
#  depends_on = [aws_internet_gateway.internet_gateway]
#}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    for key, value in var.tags : key => "${value}-public-route-table"
  }
}

resource "aws_route_table_association" "public_route_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

#resource "aws_route_table" "private_route_table" {
#  vpc_id = aws_vpc.vpc.id
#  route {
#    cidr_block     = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.nat_gateway.id
#  }
#
#  tags = {
#    for key, value in var.tags : key => "${value}-private-route-table"
#  }
#}

#resource "aws_route_table_association" "private_route_association_1" {
#  subnet_id      = aws_subnet.private_subnet_1.id
#  route_table_id = aws_route_table.private_route_table.id
#}

#resource "aws_route_table_association" "private_route_association_2" {
#  subnet_id      = aws_subnet.private_subnet_2.id
#  route_table_id = aws_route_table.private_route_table.id
#}

#resource "aws_route_table_association" "private_route_association_3" {
#  subnet_id      = aws_subnet.private_subnet_3.id
#  route_table_id = aws_route_table.private_route_table.id
#}