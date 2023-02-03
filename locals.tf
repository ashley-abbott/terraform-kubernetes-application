locals {
  service_selector      = try({ for key, value in var.service_spec[0]["selector"] : key => value if key != null }, { "app" = var.app_name })
  hpa_enabled           = can(coalesce(var.hpa_spec))
  ingress_enabled       = can(coalesce(var.ingress_spec))
  pdb_enabled           = can(coalesce(var.pod_disruption_budget_max_unavailable, var.pod_disruption_budget_min_available))
  pvc_enabled           = length(var.persistent_volume_claim_spec) == 0 ? false : true
  configmap_data        = try(merge({ for k, v in var.configmap_binary_data : k => {} }, var.configmap_data), {})
  configmap_binary_data = try(merge({ for k, v in var.configmap_data : k => {} }, var.configmap_binary_data), {})
  secret_data           = try(merge({ for k, v in var.secret_binary_data : k => {} }, var.secret_data), {})
  secret_binary_data    = try(merge({ for k, v in var.secret_data : k => {} }, var.secret_binary_data), {})
  service_accounts      = try(toset([for key, value in var.deployment_spec[*].service_account_name : value if value != null]), {})

  standard_metadata = [{
    name      = var.app_name
    namespace = try(lower(var.namespace), "default")
  }]

  deployment_metadata = [
    merge(local.standard_metadata[0], {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.deployment_labels), {})
      annotations = try(merge(var.deployment_annotations, var.common_annotations), {})
    })
  ]

  service_metadata = [
    merge(local.standard_metadata[0], {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.service_labels), {})
      annotations = try(merge(var.service_annotations, var.common_annotations), {})
    })
  ]

  hpa_metadata = [
    merge(local.standard_metadata[0], {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.hpa_labels), {})
      annotations = try(merge(var.hpa_annotations, var.common_annotations), {})
    })
  ]

  config_metadata = [
    merge(local.standard_metadata[0], {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.config_labels), {})
      annotations = try(merge(var.config_annotations, var.common_annotations), {})
    })
  ]

  secret_metadata = [
    merge(local.standard_metadata[0], {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.secret_labels), {})
      annotations = try(merge(var.secret_annotations, var.common_annotations), {})
    })
  ]

  ingress_metadata = [
    merge(local.standard_metadata[0], {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.ingress_labels), {})
      annotations = try(merge(var.ingress_annotations, var.common_annotations), {})
    })
  ]

  pdb_metadata = [
    merge(local.standard_metadata[0], {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.pod_disruption_budget_labels), {})
      annotations = try(merge(var.pod_disruption_budget_annotations, var.common_annotations), {})
    })
  ]

  pvc_metadata = [
    merge(local.standard_metadata[0], {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.persistent_volume_claim_labels), {})
      annotations = try(merge(var.persistent_volume_claim_annotations, var.common_annotations), {})
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
