resource "kubernetes_namespace" "staging" {
  metadata {
    name = "staging"
  }
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}

resource "kubernetes_deployment" "nginx_deployment_staging" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.staging.metadata[0].name
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.23.1"
          name  = "nginx"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "nginx_deployment_dev" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.23.1"
          name  = "nginx"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}