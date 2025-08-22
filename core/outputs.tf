output "vpc_id"            { value = aws_vpc.main.id }
output "bastion_subnet_id" { value = aws_subnet.bastion.id }
output "bastion_sg_id"     { value = aws_security_group.bastion_sg.id }
output "bastion_public_ip" { value = var.create_gateway ? aws_instance.bastion.public_ip : null }
output "key_name"          { value = aws_key_pair.core.key_name }
output "key_file"          { value = local_sensitive_file.pem.filename }
output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}