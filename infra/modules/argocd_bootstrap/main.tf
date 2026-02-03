# Argo CD
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "9.4.0"
  create_namespace = true

  values = [
    yamlencode({
      global = {
        domain = var.argocd_domain
      }
      configs = {
        params = {
          "server.insecure" = false
        }
        cm = {
          "url"                          = "https://${var.argocd_domain}"
          "application.instanceLabelKey" = "argocd.argoproj.io/instance"
        }
        rbac = {
          "policy.default" = "role:readonly"
          "policy.csv"     = <<-EOT
            p, role:org-admin, applications, *, */*, allow
            p, role:org-admin, clusters, *, *, allow
            p, role:org-admin, repositories, *, *, allow
            p, role:org-admin, certificates, *, *, allow
            p, role:org-admin, projects, *, *, allow
            p, role:org-admin, accounts, *, *, allow
            p, role:org-admin, gpgkeys, *, *, allow
            p, role:org-admin, logs, *, *, allow
            p, role:org-admin, exec, *, *, allow
            p, role:org-admin, applicationsets, *, *, allow
            g, argocd-admins, role:org-admin
            g, argocd-admins, role:admin
          EOT
        }
      }
      server = {
        service = {
          type = "LoadBalancer"
          annotations = {
            "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
          }
        }
        ingress = {
          enabled          = true
          ingressClassName = "nginx"
          annotations = {
            "cert-manager.io/cluster-issuer"               = "letsencrypt-prod"
            "nginx.ingress.kubernetes.io/ssl-redirect"     = "true"
            "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
          }
          hosts = [var.argocd_domain]
          tls = [
            {
              secretName = "argocd-server-tls"
              hosts      = [var.argocd_domain]
            }
          ]
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
      }
      controller = {
        nodeSelector = {
          "kubernetes.io/os" = "linux"
        }
        tolerations = [
          {
            key      = "CriticalAddonsOnly"
            operator = "Exists"
          }
        ]
      }
      repoServer = {
        nodeSelector = {
          "kubernetes.io/os" = "linux"
        }
        tolerations = [
          {
            key      = "CriticalAddonsOnly"
            operator = "Exists"
          }
        ]
      }
      applicationSet = {
        nodeSelector = {
          "kubernetes.io/os" = "linux"
        }
        tolerations = [
          {
            key      = "CriticalAddonsOnly"
            operator = "Exists"
          }
        ]
      }
      dex = {
        nodeSelector = {
          "kubernetes.io/os" = "linux"
        }
        tolerations = [
          {
            key      = "CriticalAddonsOnly"
            operator = "Exists"
          }
        ]
      }
      redis = {
        nodeSelector = {
          "kubernetes.io/os" = "linux"
        }
        tolerations = [
          {
            key      = "CriticalAddonsOnly"
            operator = "Exists"
          }
        ]
      }
    })
  ]

  depends_on = [data.azurerm_kubernetes_cluster.this]
}

# Argo CD Application for platform components
resource "kubernetes_manifest" "platform_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "platform"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.repo_url
        targetRevision = "HEAD"
        path           = var.repo_path_platform
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true",
          "ServerSideApply=true"
        ]
      }
    }
  }

  depends_on = [helm_release.argocd]
}

# Data source for AKS cluster
data "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}
