locals {
  selector            = can(coalesce(var.service_selector)) ? var.service_selector : { "app" = var.app_name }
  sha                 = { previous = var.commit_before_sha, new = var.commit_short_sha }
  revert              = (var.enable_green_deployment && var.revert_green) ? true : false
  switch              = (var.enable_green_deployment && var.switch_traffic) ? true : false
  statefulset_enabled = var.statefulset_spec == {} ? false : true
  enable_deployment   = (var.deployment_spec == {} && local.statefulset_enabled) ? false : true
  statefulset         = (local.statefulset_enabled && local.enable_deployment == false) ? toset(["statefulset"]) : toset([])
  deployment_type     = local.enable_deployment == false ? toset([]) : local.revert ? toset([local.sha["previous"]]) : local.switch ? toset([local.sha["new"]]) : var.enable_green_deployment ? toset([local.sha["previous"], local.sha["new"]]) : toset([local.sha["new"]])
  service_type        = local.statefulset_enabled ? toset(["statefulset"]) : local.deployment_type
  hpa_enabled         = can(coalesce(var.min_replicas, var.max_replicas, var.target_cpu_utilization_percentage))
  ingress_enabled     = can(coalesce(var.ingress_spec))
  pdb_enabled         = can(coalesce(var.pod_disruption_budget_max_unavailable, var.pod_disruption_budget_min_available))
  pvc_enabled         = length(var.persistent_volume_claim_spec) == 0 ? false : true
  affinity_enabled    = length(var.node_affinity) > 0 || length(var.pod_affinity) > 0 || length(var.pod_anti_affinity) > 0 ? ["affinity"] : []
  configmap_data      = { for I in keys(merge({ for k, v in var.configmap_binary_data : k => {} }, var.configmap_data)) : I => { binary = try(var.configmap_binary_data[I], {}), data = try(var.configmap_data[I], {}) } }
  secret_data         = { for I in keys(merge({ for k, v in var.secret_binary_data : k => {} }, var.secret_data)) : I => { binary = try(var.secret_binary_data[I], {}), data = try(var.secret_data[I], {}) } }
  service_accounts    = (var.use_existing_k8s_sa == true) ? toset([]) : try(toset([for key, value in var.deployment_spec[*].service_account_name : value if value != null]), toset([]))

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

  statefulset_metadata = [
    merge(local.standard_metadata[0], {
      labels      = try(merge(var.common_labels, { app = var.app_name }, var.statefulset_labels), {})
      annotations = try(merge(var.statefulset_annotations, var.common_annotations), {})
    })
  ]

  hpa_spec = [
    {
      max_replicas                      = try(var.max_replicas, 1)
      min_replicas                      = try(var.min_replicas, null)
      target_cpu_utilization_percentage = try(var.target_cpu_utilization_percentage, null)
      api_version                       = try(var.hpa_target_api_version, null)
    }
  ]
}
