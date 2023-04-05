variable "app_name" {
  type        = string
  description = "Name of the application being deployed, this will be used across multiple resources "
}

variable "namespace" {
  type        = string
  description = "The Kubernetes namespace in which you want all your resources to be deployed"
}

variable "use_existing_k8s_sa" {
  type        = bool
  description = "(optional) Boolean used to control whether to utilise a pre existing K8s service account"
  default     = false
}

# Service
variable "service_labels" {
  type        = map(string)
  description = "(optional) Additional labels that you require for the Serivce object"
  default     = {}
}

variable "service_annotations" {
  type        = map(string)
  description = "(optional) Additional annotations that you require for the Service object"
  default     = {}
}

variable "service_selector" {
  type        = map(string)
  description = "value"
  default     = null
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
    type                              = optional(string)
    ports = list(object({
      name         = optional(string)
      app_protocol = optional(string)
      port         = number
      target_port  = optional(number)
      protocol     = optional(string)
      node_port    = optional(number)
    }))
  }))
  description = "All possible arguments for the [Service spec](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1), the only required parameters are `ports = [{ \"port\" = <port-number> }]"
}

# Deployment
variable "deployment_labels" {
  type        = map(string)
  description = "(optional) Additional labels that you require for the Deployment object"
  default     = {}
}

variable "deployment_annotations" {
  type        = map(string)
  description = "(optional) Additional annotations that you require for the Deployment object"
  default     = {}
}

variable "deployment_spec" {
  type        = any
  description = <<-EOF
  Includes both Replication Controller Spec and Pod Spec, this variable is set to type `any` to allow as many or as few attributes as you desire, defaulting to the resource defaults when omitted.

  The attribute `strategy { type }` is defined as `strategy_type` for brevity see [k8s_deployment.tf](./k8s_deployment.tf#L31)

  For reference: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment#spec
  EOF
  default     = {}
}

variable "node_affinity" {
  type    = any
  default = {}
}

variable "pod_affinity" {
  type    = any
  default = {}
}

variable "pod_anti_affinity" {
  type    = any
  default = {}
}

# HPA
variable "hpa_labels" {
  type        = map(string)
  description = "(optional) Additional labels that you require for the Horizontal Pod Autoscaler object"
  default     = {}
}

variable "hpa_annotations" {
  type        = map(string)
  description = "(optional) Additional annotations that you require for the Horizontal Pod Autoscaler object"
  default     = {}
}

variable "hpa_spec" {
  type        = any
  description = "(optional) "
  default     = {}
}

variable "min_replicas" {
  type        = number
  description = "(optional) Minimum amount of replicas that you desire for the Horizontal Pod Autoscaler object"
  default     = null
}

variable "max_replicas" {
  type        = number
  description = "(optional) Maximum amount of replicas that you desire for the Horizontal Pod Autoscaler object"
  default     = null
}

variable "target_cpu_utilization_percentage" {
  type        = string
  description = "(optional) Target average CPU utilization (represented as a percentage of requested CPU) over all the pods"
  default     = null
}

variable "hpa_target_api_version" {
  type        = any
  description = "(optional) Set the API Version for scaleTargetRef"
  default     = null
}

# StatefulSet
variable "statefulset_labels" {
  type        = map(string)
  description = "(optional) Additional labels that you require for the StatefulSet object"
  default     = {}
}

variable "statefulset_annotations" {
  type        = map(string)
  description = "(optional) Additional annotations that you require for the StatefulSet object"
  default     = {}
}

variable "statefulset_spec" {
  type        = any
  description = "(optional) describe your variable"
  default     = {}
}

# Ingress
variable "ingress_labels" {
  type        = map(string)
  description = "(optional) Additional labels that you require for the Ingress object"
  default     = {}
}

variable "ingress_annotations" {
  type        = map(string)
  description = "(optional) Additional annotations that you require for the Ingress object"
  default     = {}
}

variable "ingress_spec" {
  type        = any
  description = "(optional) Conditionally create an Ingress object, if this variable isn't populated the Ingress is skipped"
  default     = null
}

# ConfigMap
variable "configmap_data" {
  type        = any
  description = "(optional) Conditionally create one or more ConfigMaps, keys from both `configmap_data` and `configmap_binary_data` will be merged allowing to specify only one of the two variables if so desired"
  default     = {}
}

variable "configmap_binary_data" {
  type        = any
  description = "(optional) Conditionally create one or more ConfigMaps, keys from both `configmap_data` and `configmap_binary_data` will be merged allowing to specify only one of the two variables if so desired. Values specified in this variable will be base64 encoded before being passed to the K8s API"
  default     = {}
}

variable "config_labels" {
  type        = map(string)
  description = "(optional) Additional labels that you require for the ConfigMap object(s)"
  default     = {}
}

variable "config_annotations" {
  type        = map(string)
  description = "(optional) Additional annotations that you require for the ConfigMap object(s)"
  default     = {}
}

# Secret
variable "secret_data" {
  type        = any
  description = "(optional) Conditionally create one or more Secrets, keys from both `secret_data` and `secret_binary_data` will be merged allowing to specify only one of the two variables if so desired"
  default     = {}
}

variable "secret_binary_data" {
  type        = any
  description = "(optional) Conditionally create one or more Secrets, keys from both `secret_data` and `secret_binary_data` will be merged allowing to specify only one of the two variables if so desired. Values specified in this variable will be base64 encoded before being passed to the K8s API"
  default     = {}
}

variable "secret_labels" {
  type        = map(string)
  description = "(optional) Additional labels that you require for the Secret object(s)"
  default     = {}
}

variable "secret_annotations" {
  type        = map(string)
  description = "(optional) Additional annotations that you require for the Secret object(s)"
  default     = {}
}

# Pod Disruption Budget
variable "pod_disruption_budget_max_unavailable" {
  type        = string
  description = "(optional) Specifies the number of pods from the selected set that can be unavailable after the eviction. It can be either an absolute number or a percentage. You can specify only one of max_unavailable and min_available in a single Pod Disruption Budget"
  default     = null
}

variable "pod_disruption_budget_min_available" {
  type        = string
  description = "(optional) Specifies the number of pods from the selected set that must still be available after the eviction, even in the absence of the evicted pod. min_available can be either an absolute number or a percentage. You can specify only one of min_available and max_unavailable in a single Pod Disruption Budget"
  default     = null
}

variable "pod_disruption_budget_labels" {
  type        = map(string)
  description = "(optional) Additional labels that you require for the PodDisruptionBudget object"
  default     = {}
}

variable "pod_disruption_budget_annotations" {
  type        = map(string)
  description = "(optional) Additional annotations that you require for the PodDisruptionBudget object"
  default     = {}
}

# Persistent Volume Claim
variable "persistent_volume_claim_spec" {
  type = list(object({
    access_modes       = optional(list(string))
    storage_request    = optional(string)
    storage_class_name = optional(string)
    volume_name        = optional(string)
  }))
  description = "(optional) Conditionally create a [PersistentVolumeClaim](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim_v1#spec), if this variable isn't populated the PVC is skipped "
  default     = []
}

variable "persistent_volume_claim_labels" {
  type        = map(string)
  description = "(optional) Additional labels that you require for the PersistentVolumeClaim object"
  default     = {}
}

variable "persistent_volume_claim_annotations" {
  type        = map(string)
  description = "(optional) Additional labels that you require for the PersistentVolumeClaim object"
  default     = {}
}

# Common 
variable "common_labels" {
  type        = map(any)
  description = "(optional) Common labels that you require across all objects being created"
  default     = {}
}

variable "common_annotations" {
  type        = map(any)
  description = "(optional) Common annotations that you require across all objects being created"
  default     = {}
}

# Initial work for blue/green
variable "commit_short_sha" { default = "00000001" }
variable "commit_before_sha" { default = "00000000" }
variable "enable_green_deployment" { default = false }
variable "revert_green" { default = false }
variable "switch_traffic" { default = false }
