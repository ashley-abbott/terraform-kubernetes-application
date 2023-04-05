resource "kubernetes_horizontal_pod_autoscaler_v2" "application" {
  count = local.hpa_enabled ? 1 : 0

  dynamic "metadata" {
    for_each = local.hpa_metadata

    content {
      name        = metadata.value["name"]
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  dynamic "spec" {
    for_each = [var.hpa_spec] # local.hpa_spec

    content {
      max_replicas                      = lookup(spec.value, "max_replicas")
      min_replicas                      = lookup(spec.value, "min_replicas", null)
      target_cpu_utilization_percentage = lookup(spec.value, "target_cpu_utilization_percentage", null)

      scale_target_ref {
        api_version = lookup(lookup(spec.value, "scale_target_ref", {}), "api_version", "apps/v1")
        kind        = lookup(lookup(spec.value, "scale_target_ref", {}), "kind", "Deployment")
        name        = lookup(lookup(spec.value, "scale_target_ref", {}), "name", local.deployment_metadata[0]["name"])
      }

      dynamic "metric" {
        for_each = try(spec.value["metrics"], [])

        content {
          type = metric.value["type"] # Object, Pods, Resource, External or ContainerResource

          dynamic "container_resource" {
            for_each = try(length(keys(lookup(metric.value, "container_resource", {}))) != 0 ? [{ for k, v in metric.value.container_resource : k => v }] : [], {})

            content {
              container = lookup(container_resource.value, "container")
              name      = lookup(container_resource.value, "name")

              target {
                # average_utilization = lookup(container_resource.value, "average_utilization", null) # Only valid for Resource metric source type
                average_value = lookup(container_resource.value, "average_value", null)
                type          = lookup(container_resource.value, "type") # Utilization, Value or AverageValue
                value         = lookup(container_resource.value, "value", null)
              }
            }
          }

          dynamic "external" {
            for_each = try(length(keys(lookup(metric.value, "external", {}))) != 0 ? [{ for k, v in metric.value.external : k => v }] : [], {})

            content {
              metric {
                name = lookup(external.value, "name")

                dynamic "selector" {
                  for_each = lookup(external.value, "selector", "empty") == "empty" ? [{}] : [{ for k, v in external.value["selector"] : k => v }]

                  content {
                    match_labels = try(selector.value["match_labels"], { app = var.app_name })

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
              }

              target {
                # average_utilization = lookup(external.value, "average_utilization", null) # Only valid for Resource metric source type
                average_value = lookup(external.value, "average_value", null)
                type          = lookup(external.value, "type")
                value         = lookup(external.value, "value", null)
              }
            }
          }

          dynamic "object" {
            for_each = try(length(keys(lookup(metric.value, "object", {}))) != 0 ? [{ for k, v in metric.value.object : k => v }] : [], {})

            content {
              described_object {
                api_version = lookup(lookup(object.value, "described_object", {}), "api_version", null)
                kind        = lookup(lookup(object.value, "described_object", {}), "kind")
                name        = lookup(lookup(object.value, "described_object", {}), "name")
              }

              metric {
                name = lookup(object.value, "name")

                dynamic "selector" {
                  for_each = lookup(object.value, "selector", "empty") == "empty" ? [{}] : [{ for k, v in object.value["selector"] : k => v }]

                  content {
                    match_labels = try(selector.value["match_labels"], { app = var.app_name })

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
              }

              target {
                # average_utilization = lookup(object.value, "average_utilization", null) # Only valid for Resource metric source type
                average_value = lookup(object.value, "average_value", null)
                type          = lookup(object.value, "type")
                value         = lookup(object.value, "value", null)
              }
            }
          }

          dynamic "pods" {
            for_each = try(length(keys(lookup(metric.value, "pods", {}))) != 0 ? [{ for k, v in metric.value.pods : k => v }] : [], {})

            content {
              metric {
                name = lookup(pods.value, "name")

                dynamic "selector" {
                  for_each = lookup(pods.value, "selector", "empty") == "empty" ? [{}] : [{ for k, v in pods.value["selector"] : k => v }]

                  content {
                    match_labels = try(selector.value["match_labels"], { app = var.app_name })

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
              }

              target {
                # average_utilization = lookup(pods.value, "average_utilization", null) # Only valid for Resource metric source type
                average_value = lookup(pods.value, "average_value", null)
                type          = lookup(pods.value, "type")
                value         = lookup(pods.value, "value", null)
              }
            }
          }

          dynamic "resource" {
            for_each = try(length(keys(lookup(metric.value, "resource", {}))) != 0 ? [{ for k, v in metric.value.resource : k => v }] : [], {})

            content {
              name = lookup(resource.value, "name")

              target {
                average_utilization = lookup(resource.value, "average_utilization", null)
                average_value       = lookup(resource.value, "average_value", null)
                type                = lookup(resource.value, "type")
                value               = lookup(resource.value, "value", null)
              }
            }
          }
        }
      }

      # dynamic "behavior" {
      #   for_each = try(spec.value.behavior, {})

      #   content {
      #     dynamic "scale_up" {

      #     }

      #     dynamic "scale_down" {

      #     }
      #   }
      # }
    }
  }
}
