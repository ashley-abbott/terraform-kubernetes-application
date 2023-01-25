resource "kubernetes_config_map" "application" {
  for_each = var.configmap_data

  dynamic "metadata" {
    for_each = local.config_metadata

    content {
      name        = "${metadata.value["name"]}-${each.key}-config"
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  # Check if variable isn't null then iterate through map
  data = (var.configmap_data != {}) ? { for key, value in var.configmap_data[each.key] : key => value } : {}

  # Check if variable isn't null then iterate through map, B64 encoding the values 
  binary_data = (var.configmap_binary_data != {}) ? { for key, value in var.configmap_binary_data[each.key] : key => base64encode(value) } : {}
}
