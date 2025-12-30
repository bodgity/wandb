# W&B Deployment

**Summary:** This is a simple deployment designed to mimic an example of a customer deployment of **Weights & Biases (W&B)** on AWS. It provisions core infrastructure using Terraform, deploys W&B via EKS and ArgoCD, and demonstrates how W&B components interact in a production-like environment.


This repository contains Terraform configurations for deploying Weights & Biases (W&B) on AWS using EKS.

## Architecture

- **bootstrap-state**: Creates S3 bucket for Terraform remote state storage.
- **long-lived-infra**: Provisions core infrastructure (VPC, EKS, ACM, RDS, S3, Load Balancer Controller, ArgoCD).
- **app-of-apps**: ArgoCD Application definitions that orchestrate deployment of W&B components.
- **charts**: Helm charts and Kubernetes manifests for W&B operator and server.

## Prerequisites

- Terraform >= 1.9.0
- AWS CLI configured with appropriate permissions
- kubectl for Kubernetes operations
- Route 53 Hosted Zone (if using a public domain)

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

3. **Deploy W&B via ArgoCD**:
   ```bash
   ./tf-to-yaml.sh # Converts Terraform outputs to W&B server manifest
   kubectl apply -f ../app-of-apps/wandb-app.yaml
   ```

## Accessing Deployed Services

Once deployed, you can access the services using port-forwarding for local development:

- **ArgoCD UI**:
  ```bash
  kubectl port-forward svc/argocd-server -n argocd 8080:443
  ```
  Access at: https://localhost:8080

  You can get the default admin password by running the following command:
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
  ```

- **W&B Server** (if needed for local access):
  ```bash
  kubectl port-forward svc/wandb-service -n wandb-cr 8081:80
  ```
  Access at: http://localhost:8081

For production access, W&B is available via the configured domain (e.g., https://wandb.joshuasross.com) through the ALB ingress. In the hosted zone, create an alias record to point the subdomain to the ALB endpoint.

## Variables

See `variables.tf` files in each directory for required and optional variables.

## Modules

- `modules/acm/`: AWS Certificate Manager certificates and DNS validation
- `modules/argocd/`: ArgoCD installation and configuration
- `modules/eks/`: EKS cluster, node groups, and IAM roles
- `modules/lb_controller/`: AWS Load Balancer Controller for EKS
- `modules/networking/`: VPC, subnets, and security groups
- `modules/rds/`: RDS MySQL instance with security groups
- `modules/storage/`: S3 buckets for W&B artifacts and backups
