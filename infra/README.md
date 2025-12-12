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

**Note**: The `Taskfile.yml` is located in the repository root. Run all `task` commands from the root directory.

1. **Bootstrap remote state** (from repository root):

   ```bash
   task init-backend RG=<resource-group> SA=<storage-account> CN=<container> LOCATION=<location>
   ```

2. **Deploy infrastructure** (from repository root):

   ```bash
   task tf-init
   task tf-plan
   task tf-apply
   ```

3. **Access private cluster** (from repository root):

   ```bash
   task kubeconfig
   az aks command invoke -g <rg> -n <cluster> --command "kubectl get nodes"
   ```

## Directory Structure

```text
infra/
├── modules/           # Reusable Terraform modules
├── envs/prod/        # Production environment
├── scripts/          # Bootstrap and utility scripts
└── README.md

Note: Taskfile.yml is in the repository root directory
```

## Security Features

- Private AKS API endpoint
- Azure Firewall egress control
- Workload Identity for all add-ons
- Network policies with Cilium
- Pod Security Admission
- Azure AD RBAC integration
- Private DNS zones for all services
