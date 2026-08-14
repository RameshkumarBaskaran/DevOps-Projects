# AWS Landing Zone using Terraform

## Overview

This project demonstrates an enterprise-grade AWS Landing Zone built using Terraform.

The project follows a modular architecture and provisions secure, scalable, and production-ready AWS infrastructure.

---

## Technologies

- Terraform
- AWS VPC
- EC2
- IAM
- Application Load Balancer
- Auto Scaling Group
- Route53
- RDS MySQL
- CloudWatch
- SNS
- CloudTrail
- VPC Flow Logs
- AWS Config
- AWS Budgets
- KMS
- Secrets Manager

---

## Project Structure

```
AWS-Landing-Zone/
│
├── modules/
│   ├── vpc
│   ├── ec2
│   ├── iam
│   ├── bastion
│   ├── rds
│   ├── monitoring
│   ├── route53
│   ├── backend
│   ├── kms
│   ├── secrets
│   ├── cloudtrail
│   ├── flowlogs
│   ├── config
│   └── budgets
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
```

---

## Features

- Modular Terraform Design
- Multi-tier VPC
- Public & Private Subnets
- NAT Gateway
- Bastion Host
- EC2 Launch Template
- Auto Scaling Group
- Application Load Balancer
- Target Groups
- Route53
- RDS Database
- IAM Hardening
- KMS Encryption
- Secrets Manager
- CloudWatch Dashboard
- CloudWatch Alarms
- SNS Notifications
- CloudTrail
- VPC Flow Logs
- AWS Config
- AWS Budgets
- Terraform Backend

---

## Deployment

```bash
terraform init

terraform fmt -recursive

terraform validate

terraform plan
```

---

## Author

Ramesh Kumar Baskaran

Cloud | DevOps | Terraform | AWS