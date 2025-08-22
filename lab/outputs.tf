output "private_ips" { value = [for i in aws_instance.lab : i.private_ip] }
