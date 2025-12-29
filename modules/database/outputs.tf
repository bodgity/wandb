output "db_host" {
  value       = aws_db_instance.wandb.address
  description = "Database host address"
}

output "db_security_group_id" {
  value       = aws_security_group.wandb_db.id
  description = "Database security group ID"
}
