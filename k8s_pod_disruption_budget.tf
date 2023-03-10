resource "kubernetes_pod_disruption_budget_v1" "application" {
  count = local.pdb_enabled ? 1 : 0

  dynamic "metadata" {
    for_each = local.pdb_metadata

    content {
      name        = metadata.value["name"]
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  spec {
    max_unavailable = try(var.pod_disruption_budget_max_unavailable, null)
    min_available   = try(var.pod_disruption_budget_min_available, null)

    dynamic "selector" {
      for_each = local.service_selector

      content {
        match_labels = local.service_selector
      }
    }
  }
}
