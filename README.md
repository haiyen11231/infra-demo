# AWS 3-Tier Terraform Demo

This project provisions a 3-tier web application on AWS using Terraform:

- VPC (network)
- EC2 app server (default: t3.micro)
- RDS PostgreSQL (db.t3.micro)


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
- default VPC exists and is being used

2. EC2 dashboard
- 1 EC2 instance (running)

3. RDS dashboard
- PostgreSQL instance (db.t3.micro)
- Not publicly accessible

4. Security Groups
- default security group is used

## Free Tier Notes

- ALB and Auto Scaling were removed to keep this demo simpler and lower cost.
- EC2/RDS free usage is limited by account eligibility, region, and monthly hour/storage quotas.
- Terraform uses the default VPC and creates a DB subnet group from its subnets for RDS placement.
- Always run terraform destroy after testing.
