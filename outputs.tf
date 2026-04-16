output "vpc_id" {
  description = "Default VPC ID used by this deployment"
  value       = data.aws_vpc.default.id
}

output "app_public_ip" {
  description = "Public IP of the app EC2 instance"
  value       = aws_instance.app.public_ip
}

output "app_public_dns" {
  description = "Public DNS name of the app EC2 instance"
  value       = aws_instance.app.public_dns
}

output "rds_endpoint" {
  description = "PostgreSQL endpoint"
  value       = aws_db_instance.postgres.address
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.main[0].dns_name : null
}
