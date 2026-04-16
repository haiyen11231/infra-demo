# AWS 3-Tier Terraform Demo

This project provisions a 3-tier web application on AWS using Terraform:

- Application Load Balancer in public subnets
- Auto Scaling Group with configurable EC2 instance type (default: t3.micro) in private app subnets
- RDS PostgreSQL db.t3.micro in private DB subnets
- Single VPC with public and private subnet tiers

## What You Need

- Terraform 1.5+
- AWS account
- AWS CLI configured locally

## Credentials: 

Use one of these local methods:

1. AWS CLI profile (recommended)

Run once:

```bash
aws configure
```

This stores credentials in local AWS config files.

2. Environment variables

```bash
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
export AWS_DEFAULT_REGION="ap-southeast-1"
```

## Set Terraform Variables

Copy the example file and set DB credentials:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit terraform.tfvars and fill in:

- db_username
- db_password
- app_instance_type (for example: t3.micro)

To list free-tier-eligible EC2 types for your account and region:

```bash
aws ec2 describe-instance-types --filters Name=free-tier-eligible,Values=true --query "InstanceTypes[].InstanceType" --output text
```

## Run Terraform Locally

From this folder:

```bash
terraform init
terraform plan
terraform apply
```

Destroy when finished to avoid charges:

```bash
terraform destroy
```

## Check on AWS Dashboard

In AWS Console, confirm these resources exist:

1. VPC dashboard
- 1 VPC
- 2 public + 4 private subnets

2. EC2 dashboard
- ALB in Load Balancers
- Target Group with healthy targets
- Auto Scaling Group and EC2 instances

3. RDS dashboard
- PostgreSQL instance (db.t3.micro)
- Not publicly accessible

4. Security Groups
- ALB SG allows inbound 80 from internet
- App SG allows inbound 80 only from ALB SG
- DB SG allows inbound 5432 only from App SG

## Free Tier Notes

- ALB is generally not Free Tier eligible and will usually incur charges.
- EC2/RDS free usage is limited by account eligibility, region, and monthly hour/storage quotas.
- ASG defaults are set to 1 instance to reduce the chance of exceeding free hours.
- NAT Gateway is intentionally not created to avoid extra hourly/data processing charges.
- Always run terraform destroy after testing.
