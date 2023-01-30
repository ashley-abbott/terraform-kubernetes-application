resource "kubernetes_ingress_v1" "application" {
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
      ingress_class_name = try(spec.value["ingress_class_name"], null)

      dynamic "default_backend" {
        for_each = try(spec.value["default_backend"], {})

        content {
          service {
            name = try(backend.value["service_name"], null)
            port {
              number = try(backend.value["service_port"], null)
            }
          }
        }
      }

      dynamic "rule" {
        for_each = spec.value["rules"]

        content {
          host = try(rule.value["host"], null)
          http {
            dynamic "path" {
              for_each = try(rule.value["paths"], {})

              content {
                path = try(path.value["path"], null)
                path_type = try(path.value["path_type"], null)

                dynamic "backend" {
                  for_each = try(path.value["backend"], {})

                  content {
                    service {
                      name = try(backend.value["service_name"], null)
                      port {
                        number = try(backend.value["service_port"], null)
                      }
                    }
                  }
                }
              }
            }
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
