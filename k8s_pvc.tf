resource "kubernetes_persistent_volume_claim_v1" "application" {
  count = local.pvc_enabled ? 1 : 0

  dynamic "metadata" {
    for_each = local.pvc_metadata

    content {
      name        = "${metadata.value["name"]}-pvc"
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  dynamic "spec" {
    for_each = var.persistent_volume_claim_spec

    content {
      storage_class_name = try(spec.value.storage_class_name, null)
      access_modes       = try(spec.value.access_modes, null)
      volume_name        = try(spec.value.volume_name, null)

      resources {
        requests = {
          storage = try(spec.value.storage_request, null)
        }
      }
    }
  }
}
