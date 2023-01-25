resource "kubernetes_secret" "application" {
  for_each = var.secret_data

  dynamic "metadata" {
    for_each = local.secret_metadata

    content {
      name        = "${metadata.value["name"]}-${each.key}-secret"
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  # Check if variable isn't null then iterate through map
  data = (var.secret_data != {}) ? { for key, value in var.secret_data[each.key] : key => value } : {}

  # Check if variable isn't null then iterate through map, B64 encoding the values 
  binary_data = (var.secret_binary_data != {}) ? { for key, value in var.secret_binary_data[each.key] : key => base64encode(value) } : {}
}
