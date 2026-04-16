variable "project_name" {
  description = "Name prefix used for resources"
  type        = string
  default     = "three-tier-demo"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-southeast-1"
}

variable "app_instance_type" {
  description = "EC2 instance type for the app server. Use a free-tier-eligible type for your account/region."
  type        = string
  default     = "t3.micro"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "PostgreSQL master username"
  type        = string
}

variable "db_password" {
  description = "PostgreSQL master password"
  type        = string
  sensitive   = true
}
