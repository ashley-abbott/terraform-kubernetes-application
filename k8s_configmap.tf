resource "kubernetes_config_map" "example" {
  count = local.config_enabled ? 1 : 0

  dynamic "metadata" {
    for_each = local.config_metadata

    content {
      name        = "${metadata.value["name"]}-config"
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  # Check if variable isn't null then iterate through map
  data = (var.configmap_data != null) ? { for key, value in var.configmap_data : key => value } : {}

  # Check if variable isn't null then iterate through map, B64 encoding the values 
  binary_data = (var.configmap_binary_data != null) ? { for key, value in var.configmap_binary_data : key => base64encode(value) } : {}
}
