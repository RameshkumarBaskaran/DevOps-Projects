# AWS Landing Zone Architecture

```text
                    Internet
                        │
                        ▼
                Route53 Hosted Zone
                        │
                        ▼
              Application Load Balancer
                        │
         ┌──────────────┴──────────────┐
         ▼                             ▼
 Auto Scaling Group             Auto Scaling Group
         │
         ▼
      EC2 Instances
         │
         ▼
      Private Subnets
         │
         ▼
     Amazon RDS MySQL

────────────────────────────────────────

Public Subnets
    │
    ▼
 Bastion Host

────────────────────────────────────────

Security

✓ IAM
✓ KMS
✓ Secrets Manager
✓ CloudTrail
✓ VPC Flow Logs
✓ AWS Config
✓ CloudWatch
✓ SNS
✓ AWS Budgets

────────────────────────────────────────

Terraform

Backend
  • S3
  • DynamoDB

Deployment

Terraform Modules
```