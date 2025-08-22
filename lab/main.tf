locals {
  size_map = { 
    small = "t3.micro", 
    medium = "t3.small", 
    large = "t3.medium" 
  }
  ami_param = (
    var.distro == "ubuntu22"
    ? "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
    : "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
  )
}
data "aws_ssm_parameter" "selected_ami" { name = local.ami_param }

locals {
  user_data = <<-EOT
    #!/bin/bash
    set -e
    if [ -f /etc/debian_version ]; then
      apt-get update -y
      apt-get install -y python3
      if [ "${var.instance_kind}" = "web" ]; then apt-get install -y apache2; systemctl enable --now apache2; fi
    else
      yum -y install python3
      if [ "${var.instance_kind}" = "web" ]; then amazon-linux-extras install -y nginx1 || yum -y install nginx; systemctl enable --now nginx; fi
    fi
  EOT
}

resource "aws_instance" "lab" {
  count                       = var.instance_count
  ami                         = data.aws_ssm_parameter.selected_ami.value
  instance_type               = local.size_map[var.size]
  subnet_id                   = aws_subnet.lab.id
  vpc_security_group_ids      = [aws_security_group.lab_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = false
  user_data                   = local.user_data
  tags = merge(var.tags, { Name = "${var.lab_name}-${format("%02d", count.index+1)}", role = var.instance_kind })
}
