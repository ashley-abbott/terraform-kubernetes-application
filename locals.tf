locals {
  service_selector = try({for key, value in var.service_spec[0]["selector"] : key => value if key != null}, {"app" = var.app_name})
  deployment_metadata = [
    {
      name = var.app_name
      namespace = try(lower(var.namespace), "default")
      labels = try(merge(var.common_labels, {app = var.app_name}, var.deployment_labels), {})
      annotations = try(merge(var.deployment_annotations, var.common_annotations), {})
    }
  ]
  service_metadata = [
    {
      name = var.app_name
      namespace = try(lower(var.namespace), "default")
      labels = try(merge(var.common_labels, {app = var.app_name}, var.service_labels), {})
      annotations = try(merge(var.service_annotations, var.common_annotations), {})
    }
  ]
}
