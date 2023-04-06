resource "kubernetes_secret_v1" "application" {
  for_each = local.secret_data

  dynamic "metadata" {
    for_each = local.metadata["secret"]

    content {
      name        = "${metadata.value["name"]}-${each.key}"
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  data        = lookup(each.value, "data", {}) != {} ? { for k, v in try(each.value.data, {}) : k => v if !(k == "type") } : {}
  binary_data = lookup(each.value, "binary", {}) != {} ? { for k, v in try(each.value.binary, {}) : k => base64encode(v) if !(k == "type") } : {}

  type = try(try(lookup(lookup(each.value, "data"), "type"), lookup(lookup(each.value, "binary"), "type")), null)
}
