# Operations Guide

This document provides operational guidance for the Azure AKS Zero-Trust Platform.

## Architecture Overview

The platform consists of two main components:
- **Infrastructure (infra/)**: Terraform-managed Azure resources
- **Applications (gitops/)**: Argo CD-managed Kubernetes applications

## Security Model

### Zero-Trust Principles
- **Private AKS API**: No public endpoint, access via `az aks command invoke`
- **Network Isolation**: Hub-spoke with Azure Firewall for egress control
- **Identity-Based Access**: Workload Identity for all add-ons
- **Least Privilege**: Minimal RBAC and network policies

### Network Security
- Private endpoints for all Azure services
- Azure Firewall with allow-list egress rules
- Network policies with Cilium
- Pod Security Admission standards

## Accessing the Platform

### Private Cluster Access
```bash
# Get cluster information
az aks command invoke -g <resource-group> -n <cluster-name> --command "kubectl get nodes"

# Get kubeconfig (if accessible)
az aks get-credentials -g <resource-group> -n <cluster-name> --admin
```

### Argo CD Access
- URL: `https://argocd.<your-domain>`
- Admin password: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d`

## Monitoring and Observability

### Log Analytics
- Centralized logging via Azure Monitor
- Defender for Cloud integration
- Container insights enabled

### Application Monitoring
- Metrics Server for HPA
- Prometheus-compatible metrics
- Azure Monitor for containers

## Backup and Disaster Recovery

### State Management
- Terraform state in Azure Storage
- State locking with Azure Storage
- Remote state configuration

### Application Backup
- Argo CD application definitions in Git
- Kubernetes resource manifests
- Configuration drift detection

## Troubleshooting

### Common Issues

1. **Private Cluster Access**
   - Ensure you're using `az aks command invoke`
   - Check network connectivity to private endpoints

2. **Argo CD Sync Issues**
   - Verify repository access
   - Check application health in Argo CD UI
   - Review sync policies and permissions

3. **Certificate Issues**
   - Verify cert-manager ClusterIssuer
   - Check DNS resolution for domain
   - Review Let's Encrypt rate limits

### Debugging Commands

```bash
# Check cluster status
az aks command invoke -g <rg> -n <cluster> --command "kubectl get nodes -o wide"

# Check Argo CD applications
az aks command invoke -g <rg> -n <cluster> --command "kubectl get applications -n argocd"

# Check ingress status
az aks command invoke -g <rg> -n <cluster> --command "kubectl get ingress -A"

# Check external secrets
az aks command invoke -g <rg> -n <cluster> --command "kubectl get secretstore -A"
```

## Maintenance

### Updates
- Kubernetes version updates via Terraform
- Helm chart updates in Argo CD
- Security patches via Azure Update Management

### Scaling
- Node pool autoscaling configured
- HPA for application scaling
- Cluster autoscaler enabled

## Security Best Practices

1. **Regular Updates**
   - Keep Kubernetes and add-ons updated
   - Apply security patches promptly
   - Review and rotate secrets

2. **Access Control**
   - Use Azure AD groups for RBAC
   - Implement least privilege access
   - Regular access reviews

3. **Network Security**
   - Review firewall rules regularly
   - Monitor network policies
   - Audit ingress/egress traffic

4. **Secrets Management**
   - Use External Secrets Operator
   - Rotate secrets regularly
   - Monitor secret access
