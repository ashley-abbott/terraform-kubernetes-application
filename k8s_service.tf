resource "kubernetes_service_v1" "application" {
  dynamic "metadata" {
    for_each = local.service_metadata
    content {
      name        = metadata.value["name"]
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  dynamic "spec" {
    for_each = var.service_spec
    content {
      selector = local.service_selector

      dynamic "port" {
        for_each = spec.value["ports"]

        content {
          name        = try(lower(port.value["name"]), "${var.app_name}-${port.value["port"]}")
          port        = port.value["port"]
          target_port = try(port.value["target_port"], null)
          protocol    = try(upper(port.value["protocol"]), null)
          node_port   = try(port.value["node_port"], null)
        }
      }
      type = try(spec.value["type"], null)
    }
  }
}
