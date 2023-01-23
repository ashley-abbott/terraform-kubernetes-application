resource "kubernetes_service_v1" "application" {
  dynamic "metadata" {
    for_each = local.service_metadata
    content {
      name        = "${metadata.value["name"]}-svc"
      namespace   = metadata.value["namespace"]
      labels      = metadata.value["labels"]
      annotations = metadata.value["annotations"]
    }
  }

  dynamic "spec" {
    for_each = var.service_spec
    content {
      allocate_load_balancer_node_ports = try(spec.allocate_load_balancer_node_ports, null)
      cluster_ip                        = try(spec.cluster_ip, null)
      cluster_ips                       = try(spec.cluster_ip, null)
      external_ips                      = try(spec.external_ips, null)
      external_name                     = try(spec.external_name, null)
      external_traffic_policy           = try(spec.external_traffic_policy, null)
      internal_traffic_policy           = try(spec.internal_traffic_policy, null)
      load_balancer_ip                  = try(spec.load_balancer_ip, null)
      session_affinity                  = try(spec.session_affinity, null)
      selector                          = local.service_selector
      type                              = try(spec.value["type"], null)

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
    }
  }
}
