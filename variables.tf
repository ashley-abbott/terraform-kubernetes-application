variable "app_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "namespace" {
  type        = string
  description = "(optional) describe your variable"
}

# Service
variable "service_labels" {
  type        = map(string)
  description = "(optional) describe your variable"
  default     = {}
}

variable "service_annotations" {
  type        = map(string)
  description = "(optional) describe your variable"
  default     = {}
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

# Deployment
variable "deployment_labels" {
  type        = map(string)
  description = "(optional) describe your variable"
  default     = {}
}

variable "deployment_annotations" {
  type        = map(string)
  description = "(optional) describe your variable"
  default     = {}
}

variable "deployment_spec" {
  type = string
  description = "(optional) describe your variable"
}

# HPA
variable "hpa_labels" {
  type        = map(string)
  description = "(optional) describe your variable"
  default     = {}
}

variable "hpa_annotations" {
  type        = map(string)
  description = "(optional) describe your variable"
  default     = {}
}

variable "hpa_spec" {
  type        = any
  description = "(optional) describe your variable"
  default     = null
}

variable "max_replicas" {
  type        = number
  description = "(optional) describe your variable"
  default     = 1
}

variable "target_cpu_utilization_percentage" {
  type        = string
  description = "(optional) describe your variable"
  default     = null
}

# Ingress
variable "ingress_labels" {
  type = map(string)
  description = "(optional) describe your variable"
}

variable "ingress_annotations" {
  type = map(string)
  description = "(optional) describe your variable"
}

variable "ingress_spec" {
  type        = any
  description = "(optional) describe your variable"
  default     = null
}

# Spec'

variable "min_replicas" {
  type        = number
  description = "(optional) describe your variable"
  default     = null
}

# Common 
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
