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
  hpa_enabled         = var.hpa_spec != {} ? true : false
  ingress_enabled     = can(coalesce(var.ingress_spec))
  pdb_enabled         = var.pod_disruption_budget_spec != {} ? true : false
  pvc_enabled         = length(var.persistent_volume_claim_spec) == 0 ? false : true
  affinity_enabled    = length(var.node_affinity) > 0 || length(var.pod_affinity) > 0 || length(var.pod_anti_affinity) > 0 ? ["affinity"] : []
  configmap_data      = { for I in keys(merge({ for k, v in var.configmap_binary_data : k => {} }, var.configmap_data)) : I => { binary = try(var.configmap_binary_data[I], {}), data = try(var.configmap_data[I], {}) } }
  secret_data         = { for I in keys(merge({ for k, v in var.secret_binary_data : k => {} }, var.secret_data)) : I => { binary = try(var.secret_binary_data[I], {}), data = try(var.secret_data[I], {}) } }
  service_accounts    = (var.use_existing_k8s_sa == true) ? toset([]) : try(toset([for key, value in var.deployment_spec[*].service_account_name : value if value != null]), toset([]))

  standard_metadata = {
    name        = var.app_name
    namespace   = lower(var.namespace)
    labels      = try(merge(var.common_labels, { app = var.app_name }), {})
    annotations = try(var.common_annotations, {})
  }

  metadata_objects = {
    configmap   = { labels = var.config_labels, annotations = var.config_annotations },
    deployment  = { labels = var.deployment_labels, annotations = var.deployment_annotations },
    hpa         = { labels = var.hpa_labels, annotations = var.hpa_annotations },
    ingress     = { labels = var.ingress_labels, annotations = var.ingress_annotations },
    pdb         = { labels = var.pod_disruption_budget_labels, annotations = var.pod_disruption_budget_annotations },
    pvc         = { labels = var.persistent_volume_claim_labels, annotations = var.persistent_volume_claim_annotations },
    secret      = { labels = var.secret_labels, annotations = var.secret_annotations },
    service     = { labels = var.service_labels, annotations = var.service_annotations },
    statefulset = { labels = var.statefulset_labels, annotations = var.statefulset_annotations }
  }

  metadata = {
    for k in keys(local.metadata_objects) : k => [
      merge(
        local.standard_metadata,
        { for each in ["labels", "annotations"] : each => merge(local.metadata_objects[k][each], local.standard_metadata[each]) }
      )
    ]
  }
}
