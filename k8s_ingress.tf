resource "kubernetes_ingress" "example_ingress" {
  count = local.ingress_enabled ? 1 : 0

  dynamic "metadata" {
    for_each = local.ingress_metadata

    content {
      name        = metadata.value["name"]
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  spec {
    backend {
      service_name = "myapp-1"
      service_port = 8080
    }

    rule {
      http {
        path {
          backend {
            service_name = "myapp-1"
            service_port = 8080
          }

          path = "/app1/*"
        }

        path {
          backend {
            service_name = "myapp-2"
            service_port = 8080
          }

          path = "/app2/*"
        }
      }
    }

    tls {
      secret_name = "tls-secret"
    }
  }
}
