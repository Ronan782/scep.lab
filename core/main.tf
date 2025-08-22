data "aws_ssm_parameter" "al2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "core" {
  key_name   = "scep-lab-key"
  public_key = tls_private_key.ssh.public_key_openssh
  tags       = merge(var.tags, { Name = "scep-lab-key" })
}

resource "local_sensitive_file" "pem" {
  filename        = "${path.module}/keys/scep-lab-key.pem"
  content         = tls_private_key.ssh.private_key_pem
  file_permission = "0400"
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ssm_parameter.al2.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.bastion.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.core.key_name
  associate_public_ip_address = var.create_igw
  user_data = file("user_data.sh")
  tags = merge(var.tags, { Name = "scep-core-bastion" })
}
