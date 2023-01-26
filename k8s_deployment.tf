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
      replicas                  = lookup(spec.value, "replicas", null)
      min_ready_seconds         = lookup(spec.value, "min_ready_seconds", null)
      paused                    = lookup(spec.value, "paused", null)
      progress_deadline_seconds = lookup(spec.value, "progress_deadline_seconds", null)
      revision_history_limit    = lookup(spec.value, "revision_history_limit", null)

      dynamic "selector" {
        for_each = local.service_selector

        content {
          match_labels = local.service_selector
        }
      }

      strategy {
        type = lookup(spec.value, "strategy_type", null)

        dynamic "rolling_update" {
          for_each = try(spec.value["rolling_update"], {})

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
          automount_service_account_token = lookup(spec.value, "automount_service_account_token" ,null)
          dns_policy = lookup(spec.value, "dns_policy", null)
          service_account_name = lookup(spec.value, "service_account_name", null)
          node_selector = lookup(spec.value, "node_selector", null)
          node_name = lookup(spec.value, "node_name", null)

          dynamic "init_container" {
            for_each = try(spec.value["podspec"].init_containers, {})

            content {
              name = init_container.value["name"]
              image = init_container.value["image"]
              image_pull_policy = lookup(init_container.value, "image_pull_policy", null)
              args = lookup(init_container.value, "args", null)
            }
          }
          dynamic "container" {
            for_each = spec.value["podspec"].containers
            
            content {
              name = try(container.value["name"], var.app_name)
              image = container.value["image"]
              image_pull_policy = lookup(container.value, "image_pull_policy", null)
              args = lookup(container.value, "args", null)
            }
          }
        }
      }
    }
  }
}
