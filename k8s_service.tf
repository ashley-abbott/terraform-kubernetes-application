resource "kubernetes_service_v1" "application" {
  for_each = local.service_type

  dynamic "metadata" {
    for_each = local.metadata["service"]

    content {
      name        = join("-", [metadata.value["name"], each.key])
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  dynamic "spec" {
    for_each = [var.service_spec]

    content {
      allocate_load_balancer_node_ports = try(spec.value["allocate_load_balancer_node_ports"], null)
      cluster_ip                        = try(spec.value["cluster_ip"], null)
      cluster_ips                       = try(spec.value["cluster_ips"], null)
      external_ips                      = try(spec.value["external_ips"], null)
      external_name                     = try(spec.value["external_name"], null)
      external_traffic_policy           = try(spec.value["external_traffic_policy"], null)
      internal_traffic_policy           = try(spec.value["internal_traffic_policy"], null)
      load_balancer_ip                  = try(spec.value["load_balancer_ip"], null)
      session_affinity                  = try(spec.value["session_affinity"], null)
      selector                          = local.service_type == ["statfulset"] ? local.selector : { app = var.app_name, revision = each.key }
      type                              = try(spec.value["type"], null)

      dynamic "port" {
        for_each = spec.value["ports"]

        content {
          name         = try(lower(port.value["name"]), "${var.app_name}-${port.value["port"]}")
          app_protocol = try(port.value["app_protocol"], null)
          port         = port.value["port"]
          target_port  = try(port.value["target_port"], null)
          protocol     = try(upper(port.value["protocol"]), null)
          node_port    = try(port.value["node_port"], null)
        }
      }
    }
  }
}
