locals {
  service_selector = try({ for key, value in var.service_spec[0]["selector"] : key => value if key != null }, { "app" = var.app_name })
  hpa_enabled      = can(coalesce(var.hpa_spec))
  ingress_enabled  = can(coalesce(var.ingress_spec))
  standard_metadata = {
    name      = var.app_name
    namespace = try(lower(var.namespace), "default")
  }

  deployment_metadata = [
    merge(local.standard_metadata, {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.deployment_labels), {})
      annotations = try(merge(var.deployment_annotations, var.common_annotations), {})
    })
  ]

  service_metadata = [
    merge(local.standard_metadata, {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.service_labels), {})
      annotations = try(merge(var.service_annotations, var.common_annotations), {})
    })
  ]

  hpa_metadata = [
    merge(local.standard_metadata, {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.hpa_labels), {})
      annotations = try(merge(var.hpa_annotations, var.common_annotations), {})
    })
  ]

  hpa_spec = [
    {
      max_replicas                      = var.max_replicas
      min_replicas                      = try(var.min_replicas, null)
      target_cpu_utilization_percentage = try(var.target_cpu_utilization_percentage, null)
    }
  ]
}
