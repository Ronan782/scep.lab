resource "aws_subnet" "lab" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.lab_subnet_cidr
  map_public_ip_on_launch = false
  tags = merge(var.tags, { Name = "subnet-${var.lab_name}" })
}

resource "aws_security_group" "lab_sg" {
  name        = "${var.lab_name}-sg"
  description = "SSH depuis bastion uniquement"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH bastion SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "sg-${var.lab_name}" })
}
