resource "kubernetes_deployment_v1" "application" {
  for_each = local.deployment_type

  dynamic "metadata" {
    for_each = local.metadata["deployment"]
    content {
      name        = join("-", [metadata.value["name"], each.key])
      namespace   = metadata.value["namespace"]
      labels      = merge(metadata.value["labels"], { revision = each.key })
      annotations = metadata.value["annotations"]
    }
  }

  dynamic "spec" {
    for_each = [var.deployment_spec]

    content {
      replicas                  = lookup(spec.value, "replicas", null)
      min_ready_seconds         = lookup(spec.value, "min_ready_seconds", null)
      paused                    = lookup(spec.value, "paused", null)
      progress_deadline_seconds = lookup(spec.value, "progress_deadline_seconds", null)
      revision_history_limit    = lookup(spec.value, "revision_history_limit", null)

      dynamic "selector" {
        for_each = lookup(spec.value, "selector", "empty") == "empty" ? [{}] : [{ for k, v in spec.value["selector"] : k => v }]

        content {
          match_labels = try(selector.value["match_labels"], { app = var.app_name, revision = each.key })

          dynamic "match_expressions" {
            for_each = try(selector.value["match_expressions"], [])
            iterator = expression

            content {
              key      = lookup(expression.value, "key", null)
              operator = lookup(expression.value, "operator", null)
              values   = lookup(expression.value, "values", null)
            }
          }
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
          for_each = local.metadata["deployment"]

          content {
            name        = metadata.value["name"]
            namespace   = metadata.value["namespace"]
            labels      = merge(metadata.value["labels"], { revision = each.key })
            annotations = metadata.value["annotations"]
          }
        }

        spec {
          automount_service_account_token = lookup(spec.value, "automount_service_account_token", null)
          dns_policy                      = lookup(spec.value, "dns_policy", null)
          service_account_name            = lookup(spec.value, "service_account_name", null)
          node_selector                   = lookup(spec.value, "node_selector", null)
          node_name                       = lookup(spec.value, "node_name", null)

          dynamic "affinity" {
            for_each = local.affinity_enabled

            content {
              dynamic "node_affinity" {
                for_each = length(var.node_affinity) > 0 ? ["node_affinity"] : []

                content {
                  dynamic "preferred_during_scheduling_ignored_during_execution" {
                    for_each = { for v in lookup(var.node_affinity, "preferred_during_scheduling_ignored_during_execution", []) : "pside" => v }

                    content {
                      weight = preferred_during_scheduling_ignored_during_execution.value["weight"]
                      preference {
                        dynamic "match_expressions" {
                          for_each = { for v in lookup(preferred_during_scheduling_ignored_during_execution.value["preference"], "match_expressions", []) : "match_exp" => v }

                          content {
                            key      = match_expressions.value["key"]
                            operator = match_expressions.value["operator"]
                            values   = lookup(match_expressions.value, "values", [])
                          }
                        }
                      }
                    }
                  }

                  dynamic "required_during_scheduling_ignored_during_execution" {
                    for_each = { for v in lookup(var.node_affinity, "required_during_scheduling_ignored_during_execution", []) : "rdside" => v }

                    content {
                      dynamic "node_selector_term" {
                        for_each = { for v in lookup(required_during_scheduling_ignored_during_execution.value, "node_selector_term", []) : "node_selector_term" => v }

                        content {
                          dynamic "match_expressions" {
                            for_each = { for v in lookup(node_selector_term.value, "match_expressions", []) : "match_exp" => v }

                            content {
                              key      = match_expressions.value["key"]
                              operator = match_expressions.value["operator"]
                              values   = lookup(match_expressions.value, "values", [])
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              dynamic "pod_affinity" {
                for_each = length(var.pod_affinity) > 0 ? ["pod_affinity"] : []

                content {
                  dynamic "preferred_during_scheduling_ignored_during_execution" {
                    for_each = { for v in lookup(var.pod_affinity, "preferred_during_scheduling_ignored_during_execution", []) : "pdside" => v }

                    content {
                      weight = preferred_during_scheduling_ignored_during_execution.value["weight"]

                      pod_affinity_term {
                        namespaces   = lookup(preferred_during_scheduling_ignored_during_execution.value["pod_affinity_term"], "namespaces", [])
                        topology_key = lookup(preferred_during_scheduling_ignored_during_execution.value["pod_affinity_term"], "topology_key", "")

                        label_selector {
                          match_labels = lookup(preferred_during_scheduling_ignored_during_execution.value["pod_affinity_term"]["label_selector"], "match_labels", {})

                          dynamic "match_expressions" {
                            for_each = { for v in lookup(preferred_during_scheduling_ignored_during_execution.value["pod_affinity_term"]["label_selector"], "match_expressions", []) : "match_exp" => v }

                            content {
                              key      = match_expressions.value["key"]
                              operator = match_expressions.value["operator"]
                              values   = lookup(match_expressions.value, "values", [])
                            }
                          }
                        }
                      }
                    }
                  }

                  dynamic "required_during_scheduling_ignored_during_execution" {
                    for_each = { for v in lookup(var.pod_affinity, "required_during_scheduling_ignored_during_execution", []) : "rdside" => v }

                    content {
                      namespaces   = lookup(required_during_scheduling_ignored_during_execution.value, "namespaces", [])
                      topology_key = lookup(required_during_scheduling_ignored_during_execution.value, "topology_key", "")

                      label_selector {
                        match_labels = lookup(required_during_scheduling_ignored_during_execution.value["label_selector"], "match_labels", {})

                        dynamic "match_expressions" {
                          for_each = { for v in lookup(required_during_scheduling_ignored_during_execution.value["label_selector"], "match_expressions", []) : "match_exp" => v }

                          content {
                            key      = match_expressions.value["key"]
                            operator = match_expressions.value["operator"]
                            values   = lookup(match_expressions.value, "values", [])
                          }
                        }
                      }
                    }
                  }
                }
              }

              dynamic "pod_anti_affinity" {
                for_each = length(var.pod_anti_affinity) > 0 ? ["pod_anti_affinity"] : []

                content {
                  dynamic "preferred_during_scheduling_ignored_during_execution" {
                    for_each = { for v in lookup(var.pod_anti_affinity, "preferred_during_scheduling_ignored_during_execution", []) : "pdside" => v }

                    content {
                      weight = preferred_during_scheduling_ignored_during_execution.value["weight"]

                      pod_affinity_term {
                        namespaces   = lookup(preferred_during_scheduling_ignored_during_execution.value["pod_affinity_term"], "namespaces", [])
                        topology_key = lookup(preferred_during_scheduling_ignored_during_execution.value["pod_affinity_term"], "topology_key", "")

                        label_selector {
                          match_labels = lookup(preferred_during_scheduling_ignored_during_execution.value["pod_affinity_term"]["label_selector"], "match_labels", {})

                          dynamic "match_expressions" {
                            for_each = { for v in lookup(preferred_during_scheduling_ignored_during_execution.value["pod_affinity_term"]["label_selector"], "match_expressions", []) : "match_exp" => v }

                            content {
                              key      = match_expressions.value["key"]
                              operator = match_expressions.value["operator"]
                              values   = lookup(match_expressions.value, "values", [])
                            }
                          }
                        }
                      }
                    }
                  }

                  dynamic "required_during_scheduling_ignored_during_execution" {
                    for_each = { for v in lookup(var.pod_anti_affinity, "required_during_scheduling_ignored_during_execution", []) : "rdside" => v }

                    content {
                      namespaces   = lookup(required_during_scheduling_ignored_during_execution.value, "namespaces", [])
                      topology_key = lookup(required_during_scheduling_ignored_during_execution.value, "topology_key", "")

                      label_selector {
                        match_labels = lookup(required_during_scheduling_ignored_during_execution.value["label_selector"], "match_labels", {})

                        dynamic "match_expressions" {
                          for_each = { for v in lookup(required_during_scheduling_ignored_during_execution.value["label_selector"], "match_expressions", []) : "match_exp" => v }

                          content {
                            key      = match_expressions.value["key"]
                            operator = match_expressions.value["operator"]
                            values   = lookup(match_expressions.value, "values", [])
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }

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
                  value = lookup(env.value, "value", null)

                  dynamic "value_from" {
                    for_each = try(lookup(env.value, "value_from"), {})

                    content {
                      dynamic "config_map_key_ref" {
                        for_each = try(lookup(lookup(env.value, "value_from"), "config_map_key_ref", "empty") != "empty" ? [{ for k, v in env.value.value_from.config_map_key_ref : k => v }] : [], {})

                        content {
                          key      = lookup(config_map_key_ref.value, "key", null)
                          name     = lookup(config_map_key_ref.value, "name", null)
                          optional = lookup(config_map_key_ref.value, "optional", null)
                        }
                      }

                      dynamic "field_ref" {
                        for_each = try(lookup(lookup(env.value, "value_from"), "field_ref", "empty") != "empty" ? [{ for k, v in env.value.value_from.field_ref : k => v }] : [], {})

                        content {
                          api_version = lookup(field_ref.value, "api_version", null)
                          field_path  = lookup(field_ref.value, "field_path", null)
                        }
                      }

                      dynamic "resource_field_ref" {
                        for_each = try(lookup(lookup(env.value, "value_from"), "resource_field_ref", "empty") != "empty" ? [{ for k, v in env.value.value_from.resource_field_ref : k => v }] : [], {})

                        content {
                          container_name = lookup(resource_field_ref.value, "container_name", null)
                          resource       = lookup(resource_field_ref.value, "resource", null)
                          divisor        = lookup(resource_field_ref.value, "divisor", null)
                        }
                      }

                      dynamic "secret_key_ref" {
                        for_each = try(lookup(lookup(env.value, "value_from"), "secret_key_ref", "empty") != "empty" ? [{ for k, v in env.value.value_from.secret_key_ref : k => v }] : [], {})

                        content {
                          key      = lookup(secret_key_ref.value, "key", null)
                          name     = lookup(secret_key_ref.value, "name", null)
                          optional = lookup(secret_key_ref.value, "optional", null)
                        }
                      }
                    }
                  }
                }
              }

              dynamic "env_from" {
                for_each = try(init_container.value["env_from"], {})

                content {
                  prefix = lookup(env_from.value, "prefix", null)

                  dynamic "config_map_ref" {
                    for_each = lookup(env_from.value, "config_map_ref", {}) != {} ? [{ for k, v in env_from.value.config_map_ref : k => v }] : []

                    content {
                      name     = lookup(config_map_ref.value, "name")
                      optional = lookup(config_map_ref.value, "optional", null)
                    }
                  }

                  dynamic "secret_ref" {
                    for_each = lookup(env_from.value, "secret_ref", {}) != {} ? [{ for k, v in env_from.value.secret_ref : k => v }] : []

                    content {
                      name     = lookup(secret_ref.value, "name")
                      optional = lookup(secret_ref.value, "optional", null)
                    }
                  }
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
                for_each = try([for k in keys(container.value) : k if k == "liveness_probe"], [])

                content {
                  failure_threshold     = try(lookup(lookup(container.value, "liveness_probe"), "failure_threshold"), null)
                  initial_delay_seconds = try(lookup(lookup(container.value, "liveness_probe"), "initial_delay_seconds"), null)
                  period_seconds        = try(lookup(lookup(container.value, "liveness_probe"), "period_seconds"), null)
                  success_threshold     = try(lookup(lookup(container.value, "liveness_probe"), "success_threshold"), null)
                  timeout_seconds       = try(lookup(lookup(container.value, "liveness_probe"), "timeout_seconds"), null)

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
              }

              dynamic "readiness_probe" {
                for_each = try([for k in keys(container.value) : k if k == "readiness_probe"], [])

                content {
                  failure_threshold     = try(lookup(lookup(container.value, "readiness_probe"), "failure_threshold"), null)
                  initial_delay_seconds = try(lookup(lookup(container.value, "readiness_probe"), "initial_delay_seconds"), null)
                  period_seconds        = try(lookup(lookup(container.value, "readiness_probe"), "period_seconds"), null)
                  success_threshold     = try(lookup(lookup(container.value, "readiness_probe"), "success_threshold"), null)
                  timeout_seconds       = try(lookup(lookup(container.value, "readiness_probe"), "timeout_seconds"), null)

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
              }

              dynamic "resources" {
                for_each = try(length(container.value["resources"]) > 0 ? ["resources"] : [], {})

                content {
                  limits = {
                    cpu    = lookup(lookup(container.value["resources"], "limits"), "cpu", null)
                    memory = lookup(lookup(container.value["resources"], "limits"), "memory", null)
                  }
                  requests = {
                    cpu    = lookup(lookup(container.value["resources"], "requests"), "cpu", null)
                    memory = lookup(lookup(container.value["resources"], "requests"), "memory", null)
                  }
                }
              }

              dynamic "env" {
                for_each = try(container.value["env"], {})

                content {
                  name  = lookup(env.value, "name")
                  value = lookup(env.value, "value", null)

                  dynamic "value_from" {
                    for_each = try(lookup(env.value, "value_from"), {})

                    content {
                      dynamic "config_map_key_ref" {
                        for_each = try(lookup(lookup(env.value, "value_from"), "config_map_key_ref", "empty") != "empty" ? [{ for k, v in env.value.value_from.config_map_key_ref : k => v }] : [], {})

                        content {
                          key      = lookup(config_map_key_ref.value, "key", null)
                          name     = lookup(config_map_key_ref.value, "name", null)
                          optional = lookup(config_map_key_ref.value, "optional", null)
                        }
                      }

                      dynamic "field_ref" {
                        for_each = try(lookup(lookup(env.value, "value_from"), "field_ref", "empty") != "empty" ? [{ for k, v in env.value.value_from.field_ref : k => v }] : [], {})

                        content {
                          api_version = lookup(field_ref.value, "api_version", null)
                          field_path  = lookup(field_ref.value, "field_path", null)
                        }
                      }

                      dynamic "resource_field_ref" {
                        for_each = try(lookup(lookup(env.value, "value_from"), "resource_field_ref", "empty") != "empty" ? [{ for k, v in env.value.value_from.resource_field_ref : k => v }] : [], {})

                        content {
                          container_name = lookup(resource_field_ref.value, "container_name", null)
                          resource       = lookup(resource_field_ref.value, "resource", null)
                          divisor        = lookup(resource_field_ref.value, "divisor", null)
                        }
                      }

                      dynamic "secret_key_ref" {
                        for_each = try(lookup(lookup(env.value, "value_from"), "secret_key_ref", "empty") != "empty" ? [{ for k, v in env.value.value_from.secret_key_ref : k => v }] : [], {})

                        content {
                          key      = lookup(secret_key_ref.value, "key", null)
                          name     = lookup(secret_key_ref.value, "name", null)
                          optional = lookup(secret_key_ref.value, "optional", null)
                        }
                      }
                    }
                  }
                }
              }

              dynamic "env_from" {
                for_each = try(container.value["env_from"], {})

                content {
                  prefix = lookup(env_from.value, "prefix", null)

                  dynamic "config_map_ref" {
                    for_each = lookup(env_from.value, "config_map_ref", {}) != {} ? [{ for k, v in env_from.value.config_map_ref : k => v }] : []

                    content {
                      name     = lookup(config_map_ref.value, "name")
                      optional = lookup(config_map_ref.value, "optional", null)
                    }
                  }

                  dynamic "secret_ref" {
                    for_each = lookup(env_from.value, "secret_ref", {}) != {} ? [{ for k, v in env_from.value.secret_ref : k => v }] : []

                    content {
                      name     = lookup(secret_ref.value, "name")
                      optional = lookup(secret_ref.value, "optional", null)
                    }
                  }
                }
              }

              dynamic "volume_mount" {
                for_each = try(container.value["volume_mount"], {})
                iterator = mount

                content {
                  name              = lookup(mount.value, "name")
                  mount_path        = lookup(mount.value, "mount_path")
                  read_only         = lookup(mount.value, "read_only", null)
                  sub_path          = lookup(mount.value, "sub_path", null)
                  mount_propagation = lookup(mount.value, "mount_propagation", null)
                }
              }
            }
          }

          # https://cloud.google.com/kubernetes-engine/docs/concepts/volumes
          dynamic "volume" {
            for_each = try(spec.value.podspec.volumes, {})

            content {
              name = volume.key

              dynamic "config_map" {
                for_each = try(length(keys(lookup(volume.value, "config_map", {}))) != 0 ? [{ for k, v in volume.value.config_map : k => v }] : [], {})

                content {
                  default_mode = lookup(config_map.value, "default_mode", null)
                  optional     = lookup(config_map.value, "optional", null)
                  name         = lookup(config_map.value, "name", null)

                  dynamic "items" {
                    for_each = lookup(config_map.value, "items", [])

                    content {
                      key = lookup(items.value, "key", null)
                      mode = lookup(items.value, "mode", null)
                      path = lookup(items.value, "path", lookup(items.value, "key"))
                    }
                  }
                }
              }

              dynamic "downward_api" {
                for_each = try(length(keys(lookup(volume.value, "downward_api", {}))) != 0 ? [{ for k, v in volume.value.downward_api : k => v }] : [], {})

                content {
                  default_mode = lookup(downward_api.value, "default_mode", null)
                  
                  dynamic "items" {
                    for_each = lookup(downward_api.value, "items", null)

                    content {
                      path = lookup(items.value, "path", lookup(items.value, "key"))
                      field_ref {
                        field_path = lookup(items.value, "field_path", null)
                      }
                    }
                  }
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

              dynamic "secret" {
                for_each = try(length(keys(lookup(volume.value, "secret", {}))) != 0 ? [{ for k, v in volume.value.secret : k => v }] : [], {})

                content {
                  default_mode = lookup(secret.value, "default_mode", null)
                  optional     = lookup(secret.value, "optional", null)
                  secret_name  = lookup(secret.value, "secret_name", null)

                  dynamic "items" {
                    for_each = [{ for k, v in lookup(secret.value, "items") : k => v }]

                    content {
                      key  = lookup(items.value, "key", null)
                      mode = lookup(items.value, "mode", null)
                      path = lookup(items.value, "path", null)
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
