resource "kubernetes_horizontal_pod_autoscaler" "application" {
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
    for_each = local.hpa_spec
    content {
      max_replicas                      = spec.value["max_replicas"]
      min_replicas                      = spec.value["min_replicas"]
      target_cpu_utilization_percentage = spec.value["target_cpu_utilization_percentage"]
      scale_target_ref {
        kind = "Deployment"
        name = local.deployment_metadata[0]["name"]
      }
    }
  }
}
