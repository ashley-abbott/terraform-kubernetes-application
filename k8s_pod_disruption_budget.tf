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

  dynamic "spec" {
    for_each = [var.pod_disruption_budget_spec]

    content {
      max_unavailable = lookup(spec.value, "max_unavailable", null)
      min_available   = lookup(spec.value, "min_available", null)

      dynamic "selector" {
        for_each = lookup(spec.value, "selector", "empty") == "empty" ? [{}] : [{ for k, v in spec.value["selector"] : k => v }]

        content {
          match_labels = try(selector.value["match_labels"], null)

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
  }
}
