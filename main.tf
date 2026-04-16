data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  name_prefix = var.project_name
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "${local.name_prefix}-db-subnets"
  subnet_ids = data.aws_subnets.default_vpc.ids

  tags = {
    Name = "${local.name_prefix}-db-subnets"
  }
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.app_instance_type
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              set -e
              cat > /tmp/index.html <<'HTML'
              <html><body><h1>Simple demo app is healthy</h1></body></html>
              HTML
              nohup python3 -m http.server 80 --directory /tmp >/var/log/simple-http.log 2>&1 &
              EOF

  tags = {
    Name = "${local.name_prefix}-app"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "${local.name_prefix}-postgres"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db.name
  multi_az               = false
  publicly_accessible    = false
  backup_retention_period = 0
  skip_final_snapshot    = true
  deletion_protection    = false

  tags = {
    Name = "${local.name_prefix}-postgres"
  }
}
