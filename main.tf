terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

resource "kubernetes_namespace" "apps" {
  metadata {
    name = var.namespace
  }
}

# Deploy private registry
resource "helm_release" "registry" {
  name       = "registry"
  chart      = "./charts/registry"
  namespace  = kubernetes_namespace.apps.metadata[0].name
  values     = [file("./values/registry.yaml")]
}

# Deploy Node.js apps
resource "helm_release" "nodejs_demo" {
  name       = "nodejs-demo"
  chart      = "./charts/nodejs-demo"
  namespace  = kubernetes_namespace.apps.metadata[0].name
  values     = [file("./values/nodejs-demo.yaml")]
}

output "registry_route" {
  value = helm_release.registry.name
}

output "app_routes" {
  value = helm_release.nodejs_demo.name
}
