resource "kubernetes_config_map" "application" {
  for_each = local.configmap_data

  dynamic "metadata" {
    for_each = local.metadata["configmap"]

    content {
      name        = "${metadata.value["name"]}-${each.key}-config"
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  data        = lookup(each.value, "data", {}) != {} ? { for k, v in try(each.value.data, {}) : k => v } : {}
  binary_data = lookup(each.value, "binary", {}) != {} ? { for k, v in try(each.value.binary, {}) : k => base64encode(v) } : {}
}
