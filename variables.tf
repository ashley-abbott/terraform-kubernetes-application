variable "app_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "namespace" {
  type = string
  description = "(optional) describe your variable"
}

variable "service_labels" {
  type = map(string)
  description = "(optional) describe your variable"
  default = {}
}

variable "service_annotations" {
  type = map(string)
  description = "(optional) describe your variable"
  default = {}
}

variable "deployment_labels" {
  type = map(string)
  description = "(optional) describe your variable"
  default = {}
}

variable "deployment_annotations" {
  type = map(string)
  description = "(optional) describe your variable"
  default = {}
}

variable "service_spec" {
  type = list(object({
    allocate_load_balancer_node_ports = optional(bool)
    cluster_ip                        = optional(string)
    cluster_ips                       = optional(list(string))
    external_ips                      = optional(list(string))
    external_name                     = optional(string)
    external_traffic_policy           = optional(string)
    internal_traffic_policy           = optional(string)
    load_balancer_ip                  = optional(string)
    session_affinity                  = optional(string)
    selector                          = optional(map(string))
    session_affinity                  = optional(string)
    type                              = optional(string)
    ports = list(object({
      name        = optional(string)
      port        = number
      target_port = optional(number)
      protocol    = optional(string)
      node_port   = optional(number)
    }))
  }))
}

variable "common_labels" {
  type        = map(any)
  description = "(optional) describe your variable"
  default     = {}
}

variable "common_annotations" {
  type        = map(any)
  description = "(optional) describe your variable"
  default     = {}
}
