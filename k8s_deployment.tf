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
          for_each = lookup(spec.value, "strategy_type", "empty") == "empty" ? [{ for k, v in try(spec.value.rolling_update, {}) : k => v }] : []

          content {
            max_surge       = lookup(rolling_update.value, "max_surge", null)
            max_unavailable = lookup(rolling_update.value, "max_unavailable", null)
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

          dynamic "image_pull_secrets" {
            for_each = try([for k, v in spec.value : v if k == "image_pull_secrets"], [])

            content {
              name = image_pull_secrets.value
            }
          }

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
                  name  = lookup(env.value, "name")
                  value = lookup(env.value, "value")

                  dynamic "value_from" {
                    for_each = try(env.value["value_from"], {})

                    content {

                    }
                  }
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

              liveness_probe {
                failure_threshold     = try(lookup(lookup(container.value, "liveness_probe"), "failure_threshold"), null)
                initial_delay_seconds = try(lookup(lookup(container.value, "liveness_probe"), "initial_delay_seconds"), null)
                period_seconds        = try(lookup(lookup(container.value, "liveness_probe"), "period_seconds"), null)
                success_threshold     = try(lookup(lookup(container.value, "liveness_probe"), "success_threshold"), null)
                timeout_seconds       = try(lookup(lookup(container.value, "liveness_probe"), "timeout_seonds"), null)

                dynamic "http_get" {
                  for_each = try(lookup(lookup(container.value, "liveness_probe"), "type") == "http_get" ? [{ for k, v in container.value.liveness_probe : k => v if !(k == "type") }] : [], {})

                  content {
                    path = lookup(http_get.value, "path", null)
                    port = lookup(http_get.value, "port", null)
                  }
                }

                dynamic "tcp_socket" {
                  for_each = try(lookup(lookup(container.value, "liveness_probe"), "type") == "tcp_socket" ? [{ for k, v in container.value.liveness_probe : k => v if !(k == "type") }] : [], {})

                  content {
                    port = lookup(tcp_socket.value, "port", null)
                  }
                }

                dynamic "exec" {
                  for_each = try(lookup(lookup(container.value, "liveness_probe"), "type") == "exec" ? [{ for k, v in container.value.liveness_probe : k => v if !(k == "type") }] : [], {})

                  content {
                    command = lookup(exec.value, "command", null)
                  }
                }
              }

              readiness_probe {
                failure_threshold     = try(lookup(lookup(container.value, "readiness_probe"), "failure_threshold"), null)
                initial_delay_seconds = try(lookup(lookup(container.value, "readiness_probe"), "initial_delay_seconds"), null)
                period_seconds        = try(lookup(lookup(container.value, "readiness_probe"), "period_seconds"), null)
                success_threshold     = try(lookup(lookup(container.value, "readiness_probe"), "success_threshold"), null)
                timeout_seconds       = try(lookup(lookup(container.value, "readiness_probe"), "timeout_seonds"), null)

                dynamic "http_get" {
                  for_each = try(lookup(lookup(container.value, "readiness_probe"), "type") == "http_get" ? [{ for k, v in container.value.readiness_probe : k => v if !(k == "type") }] : [], {})
                  
                  content {
                    path = lookup(http_get.value, "path", null)
                    port = lookup(http_get.value, "port", null)
                  }
                }

                dynamic "tcp_socket" {
                  for_each = try(lookup(lookup(container.value, "readiness_probe"), "type") == "tcp_socket" ? [{ for k, v in container.value.readiness_probe : k => v if !(k == "type") }] : [], {})

                  content {
                    port = lookup(tcp_socket.value, "port", null)
                  }
                }

                dynamic "exec" {
                  for_each = try(lookup(lookup(container.value, "readiness_probe"), "type") == "exec" ? [{ for k, v in container.value.readiness_probe : k => v if !(k == "type") }] : [], {})

                  content {
                    command = lookup(exec.value, "command", null)
                  }
                }
              }

              dynamic "resources" {
                for_each = try(container.value["resources"], {})

                content {
                  limits = {
                    cpu    = lookup(resources.value.limits, "cpu", null)
                    memory = lookup(resources.value.limits, "memory", null)
                  }
                  requests = {
                    cpu    = lookup(resources.value.requests, "cpu", null)
                    memory = lookup(resources.value.requests, "memory", null)
                  }
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
                  read_only = lookup(mount.value, "read_only", null)
                  sub_path = lookup(mount.value, "sub_path", null)
                  mount_propagation = lookup(mount.value, "mount_propagation", null)
                }
              }
            }
          }

          # https://cloud.google.com/kubernetes-engine/docs/concepts/volumes
          dynamic "volume" {
            for_each = try(spec.value.podspec.volumes, {})

            content {
              name = lookup(volume.value, "name")
              dynamic "config_map" {
                for_each = try(length(keys(lookup(volume.value, "config_map", {}))) != 0 ? [{ for k, v in volume.value.config_map : k => v }] : [], {})

                content {
                  default_mode = lookup(config_map.value, "default_mode", null)
                  # items = [] #lookup(config_map.value, "items", null)
                  optional = lookup(config_map.value, "optional", null)
                  name     = lookup(config_map.value, "name", null)
                }
              }

              dynamic "downward_api" {
                for_each = try(length(keys(lookup(volume.value, "downward_api", {}))) != 0 ? [{ for k, v in volume.value.downward_api : k => v }] : [], {})

                content {
                  default_mode = lookup(downward_api.value, "default_mode", null)
                  # items = lookup(downward_api.value, "items", null)
                }
              }

              dynamic "empty_dir" {
                for_each = try(length(keys(lookup(volume.value, "empty_dir", {}))) != 0 ? [{ for k, v in volume.value.empty_dir : k => v }] : [], {})

                content {
                  medium     = lookup(empty_dir.value, "medium", null)
                  size_limit = lookup(empty_dir.value, "size_limit", null)
                }
              }

              dynamic "persistent_volume_claim" {
                for_each = try(length(keys(lookup(volume.value, "persistent_volume_claim", {}))) != 0 ? [{ for k, v in volume.value.persistent_volume_claim : k => v }] : [], {})
                content {
                  claim_name = lookup(persistent_volume_claim.value, "claim_name", null)
                  read_only  = lookup(persistent_volume_claim.value, "read_only", null)
                }
              }

              # dynamic "secret" {
              #   for_each = try(length(keys(lookup(volume.value, "secret", {}))) != 0 ? [{ for k,v in volume.value.secret : k => v }] : [], {})

              #   content {
              #     default_mode = lookup(secret.value, "default_mode", null)
              #     items = [{ for k, v in something : k => v }]
              #     optional = lookup(secret.value, "optional", null)
              #     secret_name = lookup(secret.value, "secret_name", null)
              #   }
              # }
            }
          }
        }
      }
    }
  }
}
