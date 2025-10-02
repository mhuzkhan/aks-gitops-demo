# Azure AKS Zero-Trust Platform - Infrastructure

This repository contains Terraform infrastructure-as-code for a production-grade Azure AKS platform with zero-trust security principles.

## Architecture

- **Hub-Spoke Network**: Centralized security with Azure Firewall Premium
- **Private AKS**: No public API endpoint, admin access via `az aks command invoke`
- **Zero-Trust**: Private endpoints, restrictive egress, Workload Identity, Network Policies
- **GitOps**: Argo CD bootstrapped to deploy from sibling `gitops/` repository

## Prerequisites

- Terraform >= 1.12
- Azure CLI
- Task (for orchestration)

## Quick Start

1. **Bootstrap remote state**:
   ```bash
   cd scripts
   ./bootstrap-backend.sh <resource-group> <storage-account> <container> <location>
   ```

2. **Deploy infrastructure**:
   ```bash
   task tf-init
   task tf-plan
   task tf-apply
   ```

3. **Access private cluster**:
   ```bash
   task kubeconfig
   az aks command invoke -g <rg> -n <cluster> --command "kubectl get nodes"
   ```

## Directory Structure

```
infra/
├── modules/           # Reusable Terraform modules
├── envs/prod/        # Production environment
├── scripts/          # Bootstrap and utility scripts
├── Taskfile.yml      # Task orchestration
└── README.md
```

## Security Features

- Private AKS API endpoint
- Azure Firewall egress control
- Workload Identity for all add-ons
- Network policies with Cilium
- Pod Security Admission
- Azure AD RBAC integration
- Private DNS zones for all services
