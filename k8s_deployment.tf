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

  spec {
    replicas          = 3
    min_ready_seconds = 300
    paused            = false

    dynamic "selector" {
      for_each = local.service_selector

      content {
        match_labels = local.service_selector
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
