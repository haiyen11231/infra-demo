output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer"
  value       = aws_lb.web.dns_name
}

output "rds_endpoint" {
  description = "PostgreSQL endpoint"
  value       = aws_db_instance.postgres.address
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}
