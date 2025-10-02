# Metrics Server
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "3.13.0"

  values = [
    yamlencode({
      args = [
        "--cert-dir=/tmp",
        "--secure-port=10250",
        "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
        "--kubelet-use-node-status-port",
        "--metric-resolution=15s"
      ]
      nodeSelector = {
        "kubernetes.io/os" = "linux"
      }
      tolerations = [
        {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
        }
      ]
    })
  ]

  depends_on = [data.azurerm_kubernetes_cluster.this]
}

# Ingress NGINX
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  version          = "4.10.0"
  create_namespace = true

  values = [
    yamlencode(merge({
      controller = {
        service = {
          type        = "LoadBalancer"
          annotations = var.ingress_nginx.annotations
        }
        nodeSelector = {
          "kubernetes.io/os" = "linux"
        }
        tolerations = [
          {
            key      = "CriticalAddonsOnly"
            operator = "Exists"
          }
        ]
        resources = {
          requests = {
            cpu    = "100m"
            memory = "90Mi"
          }
          limits = {
            cpu    = "500m"
            memory = "512Mi"
          }
        }
      }
    }, var.ingress_nginx))
  ]

  depends_on = [data.azurerm_kubernetes_cluster.this]
}

# Cert Manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  version          = "v1.14.0"
  create_namespace = true

  values = [
    yamlencode({
      installCRDs = true
      nodeSelector = {
        "kubernetes.io/os" = "linux"
      }
      tolerations = [
        {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
        }
      ]
    })
  ]

  depends_on = [data.azurerm_kubernetes_cluster.this]
}

# Cert Manager ClusterIssuer
resource "kubernetes_manifest" "cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = var.cert_manager.email
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [helm_release.cert_manager]
}

# CSI Secrets Store Driver
resource "helm_release" "csi_secrets_store" {
  name       = "csi-secrets-store"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"
  version    = "1.3.4"

  values = [
    yamlencode({
      nodeSelector = {
        "kubernetes.io/os" = "linux"
      }
      tolerations = [
        {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
        }
      ]
    })
  ]

  depends_on = [data.azurerm_kubernetes_cluster.this]
}

# Azure Key Vault Provider for CSI
resource "helm_release" "csi_keyvault_provider" {
  name       = "csi-keyvault-provider"
  repository = "https://azure.github.io/secrets-store-csi-driver-provider-azure/charts"
  chart      = "csi-secrets-store-provider-azure"
  namespace  = "kube-system"
  version    = "1.4.0"

  values = [
    yamlencode({
      nodeSelector = {
        "kubernetes.io/os" = "linux"
      }
      tolerations = [
        {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
        }
      ]
    })
  ]

  depends_on = [helm_release.csi_secrets_store]
}

# External Secrets Operator
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets-system"
  version          = "0.9.11"
  create_namespace = true

  values = [
    yamlencode({
      serviceAccount = {
        annotations = {
          "azure.workload.identity/client-id" = var.external_secrets.uami_client_id
        }
      }
      nodeSelector = {
        "kubernetes.io/os" = "linux"
      }
      tolerations = [
        {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
        }
      ]
    })
  ]

  depends_on = [data.azurerm_kubernetes_cluster.this]
}

# External DNS
resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  namespace        = "external-dns"
  version          = "1.13.1"
  create_namespace = true

  values = [
    yamlencode({
      provider = "azure"
      azure = {
        resourceGroup               = var.external_dns.dns_zone_rg
        tenantId                    = data.azurerm_client_config.current.tenant_id
        subscriptionId              = data.azurerm_client_config.current.subscription_id
        useManagedIdentityExtension = true
        userAssignedIdentityID      = var.external_dns.uami_client_id
      }
      domainFilters = [var.external_dns.dns_zone_name]
      txtOwnerId    = "external-dns"
      policy        = "sync"
      logLevel      = "info"
      nodeSelector = {
        "kubernetes.io/os" = "linux"
      }
      tolerations = [
        {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
        }
      ]
    })
  ]

  depends_on = [data.azurerm_kubernetes_cluster.this]
}

# Data source for AKS cluster
data "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

# Data source for current Azure client config
data "azurerm_client_config" "current" {}
