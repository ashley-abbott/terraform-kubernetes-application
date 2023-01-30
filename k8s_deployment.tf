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
          automount_service_account_token = lookup(spec.value, "automount_service_account_token", null)
          dns_policy                      = lookup(spec.value, "dns_policy", null)
          service_account_name            = lookup(spec.value, "service_account_name", null)
          node_selector                   = lookup(spec.value, "node_selector", null)
          node_name                       = lookup(spec.value, "node_name", null)

          dynamic "init_container" {
            for_each = try(spec.value["podspec"].init_containers, {})

            content {
              name              = init_container.value["name"]
              image             = init_container.value["image"]
              image_pull_policy = lookup(init_container.value, "image_pull_policy", null)
              args              = lookup(init_container.value, "args", null)

              dynamic "env" {
                for_each = try(init_container.value["env"], {})

                content {
                  name = lookup(env.value, "name")
                }
              }

              dynamic "env_from" {
                for_each = try(init_container.value["env_from"], {})

                content {
                }
              }
            }
          }
          dynamic "container" {
            for_each = try(spec.value["podspec"].containers, {})

            content {
              args              = lookup(container.value, "args", null)
              command           = lookup(container.value, "command", null)
              name              = try(container.value["name"], var.app_name)
              image             = container.value["image"]
              image_pull_policy = lookup(container.value, "image_pull_policy", null)

              dynamic "liveness_probe" {
                for_each = try(container.value["liveness_probe"], {})

                content {

                }
              }

              dynamic "readiness_probe" {
                for_each = try(container.value["readiness_probe"], {})

                content {

                }
              }

              dynamic "resources" {
                for_each = try(container.value["resources"], {})

                content {

                }
              }

              dynamic "env" {
                for_each = try(container.value["env"], {})

                content {
                  name  = lookup(env.value, "name")
                  value = lookup(env.value, "value")
                }
              }

              dynamic "env_from" {
                for_each = try(container.value["env_from"], {})

                content {

                }
              }

              dynamic "volume_mount" {
                for_each = try(container.value["volume_mount"], {})
                iterator = mount
                content {
                  name       = lookup(mount.value, "name")
                  mount_path = lookup(mount.value, "mount_path")
                }
              }
            }
          }

          dynamic "volume" {
            for_each = try(spec.value["volumes"], {})

            content {
              name = lookup(volume.value, "name", null)

            }
          }
        }
      }
    }
  }
}
