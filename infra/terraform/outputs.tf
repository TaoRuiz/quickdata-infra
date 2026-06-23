output "ip_publique_kong" {
  description = "IP publique kong"
  value       = aws_instance.kong.public_ip
}

output "ip_publique_bastion" {
  description = "IP publique bastion"
  value       = aws_instance.bastion.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.nocodb_postgres.address
}