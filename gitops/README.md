# Azure AKS Zero-Trust Platform - GitOps

This repository contains the GitOps applications and configurations for the Azure AKS Zero-Trust Platform.

## Repository Structure

```
gitops/
├── apps/                    # Application Helm charts
│   └── hello-api/          # Sample Go API application
├── argocd/                 # Argo CD configurations
│   ├── projects/           # Argo CD projects
│   └── applicationsets/    # Argo CD ApplicationSets
├── k8s-platform/           # Platform-level Kubernetes resources
└── docs/                   # Documentation
```

## Applications

### hello-api
A sample Go API application that demonstrates:
- Distroless container image
- Health checks (liveness/readiness probes)
- Horizontal Pod Autoscaler (HPA)
- Pod Disruption Budget (PDB)
- Network policies
- TLS ingress with cert-manager
- External secrets integration with Azure Key Vault

## Argo CD Projects

- **platform**: Platform-level components and configurations
- **workloads**: Application workloads

## Getting Started

1. **Deploy Infrastructure**: Follow the `infra/` repository instructions
2. **Argo CD Bootstrap**: The infrastructure will automatically bootstrap Argo CD
3. **Application Deployment**: Argo CD will automatically deploy applications from this repository

## Security Features

- Network policies for pod-to-pod communication
- Pod Security Admission standards
- TLS termination with automatic certificate management
- Secrets management via External Secrets Operator
- Workload Identity for Azure service authentication
