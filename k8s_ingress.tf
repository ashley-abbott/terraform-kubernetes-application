resource "kubernetes_ingress" "application" {
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

  dynamic "spec" {
    for_each = var.ingress_spec

    content {
      dynamic "backend" {
        for_each = try(spec.value["backend"], {})

        content {
          service_name = try(backend.value["service_name"], null)
          service_port = try(backend.value["service_port"], null)
        }
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

      dynamic "tls" {
        for_each = try(spec.value["tls"], {})

        content {
          hosts = try(tls.value.hosts, [])
          secret_name = try(tls.value.hosts, null)
        }
      }
    }
  }
}
