#!/bin/bash

# Print AKS cluster information and kubeconfig
# Usage: ./print-aks-kubeconfig.sh

set -e

echo "=== AKS Cluster Information ==="
echo "Getting cluster information..."

# Get cluster info using az aks command invoke
az aks command invoke \
    --resource-group "rg-prod-EastUS" \
    --name "aks-prod-EastUS" \
    --command "kubectl get nodes -o wide" || echo "Cluster not accessible via command invoke"

echo ""
echo "=== Cluster Access Commands ==="
echo "To access the private cluster, use:"
echo "  az aks command invoke -g <resource-group> -n <cluster-name> --command 'kubectl get nodes'"
echo ""
echo "To get kubeconfig (if cluster is accessible):"
echo "  az aks get-credentials -g <resource-group> -n <cluster-name> --admin"
echo ""
echo "=== Argo CD Access ==="
echo "Argo CD will be available at: https://argocd.<your-domain>"
echo "Default admin password can be retrieved with:"
echo "  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
