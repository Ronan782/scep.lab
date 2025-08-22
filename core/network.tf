resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, { Name = "scep-core-vpc" })
}

resource "aws_internet_gateway" "gateway" {
  count  = var.create_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "scep-core-gateway" })
}

resource "aws_subnet" "bastion" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.bastion_subnet_cidr
  map_public_ip_on_launch = var.create_gateway
  tags = merge(var.tags, { Name = "scep-core-bastion-subnet" })
}

resource "aws_route_table" "bastion" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "scep-core-rt-bastion" })
}

resource "aws_route" "bastion_default" {
  count                  = var.create_gateway ? 1 : 0
  route_table_id         = aws_route_table.bastion.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway[0].id
}

resource "aws_route_table_association" "bastion" {
  subnet_id      = aws_subnet.bastion.id
  route_table_id = aws_route_table.bastion.id
}

resource "aws_security_group" "bastion_sg" {
  name        = "scep-core-bastion-sg"
  description = "SSH vers bastion"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.create_gateway ? [1] : []
    content {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.Ip_cidr]
    }
  }
  ingress {
    description = "SSH intra-VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    description = "HTTP proxy VPC to bastion"
    from_port   = 3128
    to_port     = 3128
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "scep-core-bastion" })
}
