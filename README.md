# W&B Terraform Infrastructure

This repository contains Terraform configurations for deploying Weights & Biases (W&B) on AWS using EKS.

## Architecture

- **bootstrap-state/**: Creates S3 bucket for Terraform remote state storage.
- **long-lived-infra/**: Provisions core infrastructure (VPC, EKS, ACM, Load Balancer Controller).
- **Root directory**: Deploys W&B application components (RDS, S3, Helm charts, Kubernetes manifests).

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with appropriate permissions
- kubectl for Kubernetes operations

## Deployment

1. **Bootstrap state**:
   ```bash
   cd bootstrap-state
   terraform init
   terraform apply
   ```

2. **Deploy long-lived infrastructure**:
   ```bash
   cd long-lived-infra
   terraform init
   terraform apply
   ```

3. **Deploy W&B application**:
   ```bash
   terraform init
   terraform apply
   ```

## Variables

See `variables.tf` files in each directory for required and optional variables.

## Modules

- `modules/database/`: RDS MySQL instance with security groups
- `modules/lb_controller/`: AWS Load Balancer Controller for EKS

## Security

- All resources are encrypted at rest
- Sensitive variables are marked as such
- IAM roles follow least privilege principles
- S3 buckets have public access blocked

## Best Practices

- Uses Terraform modules for reusability
- Implements remote state with locking
- Validates input variables
- Tags resources consistently
- Separates environments using workspaces
