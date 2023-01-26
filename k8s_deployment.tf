resource "kubernetes_deployment" "application" {
  dynamic "metadata" {
    for_each = local.deployment_metadata
    content {
      name        = metadata.value["name"]
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  dynamic "spec" {
    for_each = var.deployment_spec

    content {
      replicas          = spec.value["replicas"]
      min_ready_seconds = null
      paused            = false

      dynamic "selector" {
        for_each = local.service_selector

        content {
          match_labels = local.service_selector
        }
      }

      strategy {
        type = var.deployment_strategy.type

        dynamic "rolling_update" {
          for_each = var.deployment_strategy.type == "RollingUpdate" ? var.deployment_strategy["rolling_update"] : []

          content {
            max_surge       = rolling_update.value["max_surge"]
            max_unavailable = rolling_update.value["max_unavailable"]
          }
        }
      }

      template {
        dynamic "metadata" {
          for_each = local.deployment_metadata
          content {
            name        = metadata.value["name"]
            namespace   = metadata.value["namespace"]
            labels      = metadata.value["labels"]
            annotations = metadata.value["annotations"]
          }
        }

        spec {
          container {
            name  = "test"
            image = "nginx:latest"
          }
        }
      }
    }
  }
}
