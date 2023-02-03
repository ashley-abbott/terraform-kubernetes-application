# terraform-kubernetes-application

This code is designed with Helm in mind to create a generic K8s application

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.16.1 |

## Usage

Basic usage of this module is as follows:
```hcl
module "k8s-application" {
	 source  = "<module-path>"

	 # Required variables
	 app_name  = 
	 namespace  = 
	 service_spec  = 

	 # Optional variables
	 common_annotations  = {}
	 common_labels  = {}
	 config_annotations  = {}
	 config_labels  = {}
	 configmap_binary_data  = {}
	 configmap_data  = {}
	 deployment_annotations  = {}
	 deployment_labels  = {}
	 deployment_spec  = [
  {}
]
	 hpa_annotations  = {}
	 hpa_labels  = {}
	 ingress_annotations  = {}
	 ingress_labels  = {}
	 ingress_spec  = null
	 max_replicas  = null
	 min_replicas  = null
	 persistent_volume_claim_annotations  = {}
	 persistent_volume_claim_labels  = {}
	 persistent_volume_claim_spec  = []
	 pod_disruption_budget_annotations  = {}
	 pod_disruption_budget_labels  = {}
	 pod_disruption_budget_max_unavailable  = null
	 pod_disruption_budget_min_available  = null
	 secret_annotations  = {}
	 secret_binary_data  = {}
	 secret_data  = {}
	 secret_labels  = {}
	 service_annotations  = {}
	 service_labels  = {}
	 target_cpu_utilization_percentage  = null
}
```

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/config_map) | resource |
| [kubernetes_deployment.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/deployment) | resource |
| [kubernetes_horizontal_pod_autoscaler.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/horizontal_pod_autoscaler) | resource |
| [kubernetes_ingress_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/ingress_v1) | resource |
| [kubernetes_persistent_volume_claim_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/persistent_volume_claim_v1) | resource |
| [kubernetes_pod_disruption_budget_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/pod_disruption_budget_v1) | resource |
| [kubernetes_secret.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/secret) | resource |
| [kubernetes_secret_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/secret_v1) | resource |
| [kubernetes_service_account_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/service_account_v1) | resource |
| [kubernetes_service_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/service_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the application being deployed, this will be used across multiple resources | `string` | n/a | yes |
| <a name="input_common_annotations"></a> [common\_annotations](#input\_common\_annotations) | (optional) Common annotations that you require across all objects being created | `map(any)` | `{}` | no |
| <a name="input_common_labels"></a> [common\_labels](#input\_common\_labels) | (optional) Common labels that you require across all objects being created | `map(any)` | `{}` | no |
| <a name="input_config_annotations"></a> [config\_annotations](#input\_config\_annotations) | (optional) Additional annotations that you require for the ConfigMap object(s) | `map(string)` | `{}` | no |
| <a name="input_config_labels"></a> [config\_labels](#input\_config\_labels) | (optional) Additional labels that you require for the ConfigMap object(s) | `map(string)` | `{}` | no |
| <a name="input_configmap_binary_data"></a> [configmap\_binary\_data](#input\_configmap\_binary\_data) | (optional) Conditionally create one or more ConfigMaps, keys from both `configmap_data` and `configmap_binary_data` will be merged allowing to specify only one of the two variables if so desired. Values specified in this variable will be base64 encoded before being passed to the K8s API | `any` | `{}` | no |
| <a name="input_configmap_data"></a> [configmap\_data](#input\_configmap\_data) | (optional) Conditionally create one or more ConfigMaps, keys from both `configmap_data` and `configmap_binary_data` will be merged allowing to specify only one of the two variables if so desired | `any` | `{}` | no |
| <a name="input_deployment_annotations"></a> [deployment\_annotations](#input\_deployment\_annotations) | (optional) Additional annotations that you require for the Deployment object | `map(string)` | `{}` | no |
| <a name="input_deployment_labels"></a> [deployment\_labels](#input\_deployment\_labels) | (optional) Additional labels that you require for the Deployment object | `map(string)` | `{}` | no |
| <a name="input_deployment_spec"></a> [deployment\_spec](#input\_deployment\_spec) | Includes both Replication Controller Spec and Pod Spec, this variable is set to type `any` to allow as many or as few attributes as you desire, defaulting to the resource defaults when omitted.<br><br>The attribute `strategy { type }` is defined as `strategy_type` for brevity see [k8s\_deployment.tf](./k8s\_deployment.tf#L31)<br><br>For reference: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment#spec | `any` | <pre>[<br>  {}<br>]</pre> | no |
| <a name="input_hpa_annotations"></a> [hpa\_annotations](#input\_hpa\_annotations) | (optional) Additional annotations that you require for the Horizontal Pod Autoscaler object | `map(string)` | `{}` | no |
| <a name="input_hpa_labels"></a> [hpa\_labels](#input\_hpa\_labels) | (optional) Additional labels that you require for the Horizontal Pod Autoscaler object | `map(string)` | `{}` | no |
| <a name="input_ingress_annotations"></a> [ingress\_annotations](#input\_ingress\_annotations) | (optional) Additional annotations that you require for the Ingress object | `map(string)` | `{}` | no |
| <a name="input_ingress_labels"></a> [ingress\_labels](#input\_ingress\_labels) | (optional) Additional labels that you require for the Ingress object | `map(string)` | `{}` | no |
| <a name="input_ingress_spec"></a> [ingress\_spec](#input\_ingress\_spec) | (optional) Conditionally create an Ingress object, if this variable isn't populated the Ingress is skipped | `any` | `null` | no |
| <a name="input_max_replicas"></a> [max\_replicas](#input\_max\_replicas) | (optional) Maximum amount of replicas that you desire for the Horizontal Pod Autoscaler object | `number` | `null` | no |
| <a name="input_min_replicas"></a> [min\_replicas](#input\_min\_replicas) | (optional) Minimum amount of replicas that you desire for the Horizontal Pod Autoscaler object | `number` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace in which you want all your resources to be deployed | `string` | n/a | yes |
| <a name="input_persistent_volume_claim_annotations"></a> [persistent\_volume\_claim\_annotations](#input\_persistent\_volume\_claim\_annotations) | (optional) Additional labels that you require for the PersistentVolumeClaim object | `map(string)` | `{}` | no |
| <a name="input_persistent_volume_claim_labels"></a> [persistent\_volume\_claim\_labels](#input\_persistent\_volume\_claim\_labels) | (optional) Additional labels that you require for the PersistentVolumeClaim object | `map(string)` | `{}` | no |
| <a name="input_persistent_volume_claim_spec"></a> [persistent\_volume\_claim\_spec](#input\_persistent\_volume\_claim\_spec) | (optional) Conditionally create a [PersistentVolumeClaim](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim_v1#spec), if this variable isn't populated the PVC is skipped | <pre>list(object({<br>    access_modes       = optional(list(string))<br>    storage_request    = optional(string)<br>    storage_class_name = optional(string)<br>    volume_name        = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_pod_disruption_budget_annotations"></a> [pod\_disruption\_budget\_annotations](#input\_pod\_disruption\_budget\_annotations) | (optional) Additional annotations that you require for the PodDisruptionBudget object | `map(string)` | `{}` | no |
| <a name="input_pod_disruption_budget_labels"></a> [pod\_disruption\_budget\_labels](#input\_pod\_disruption\_budget\_labels) | (optional) Additional labels that you require for the PodDisruptionBudget object | `map(string)` | `{}` | no |
| <a name="input_pod_disruption_budget_max_unavailable"></a> [pod\_disruption\_budget\_max\_unavailable](#input\_pod\_disruption\_budget\_max\_unavailable) | (optional) Specifies the number of pods from the selected set that can be unavailable after the eviction. It can be either an absolute number or a percentage. You can specify only one of max\_unavailable and min\_available in a single Pod Disruption Budget | `string` | `null` | no |
| <a name="input_pod_disruption_budget_min_available"></a> [pod\_disruption\_budget\_min\_available](#input\_pod\_disruption\_budget\_min\_available) | (optional) Specifies the number of pods from the selected set that must still be available after the eviction, even in the absence of the evicted pod. min\_available can be either an absolute number or a percentage. You can specify only one of min\_available and max\_unavailable in a single Pod Disruption Budget | `string` | `null` | no |
| <a name="input_secret_annotations"></a> [secret\_annotations](#input\_secret\_annotations) | (optional) Additional annotations that you require for the Secret object(s) | `map(string)` | `{}` | no |
| <a name="input_secret_binary_data"></a> [secret\_binary\_data](#input\_secret\_binary\_data) | (optional) Conditionally create one or more Secrets, keys from both `secret_data` and `secret_binary_data` will be merged allowing to specify only one of the two variables if so desired. Values specified in this variable will be base64 encoded before being passed to the K8s API | `any` | `{}` | no |
| <a name="input_secret_data"></a> [secret\_data](#input\_secret\_data) | (optional) Conditionally create one or more Secrets, keys from both `secret_data` and `secret_binary_data` will be merged allowing to specify only one of the two variables if so desired | `any` | `{}` | no |
| <a name="input_secret_labels"></a> [secret\_labels](#input\_secret\_labels) | (optional) Additional labels that you require for the Secret object(s) | `map(string)` | `{}` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | (optional) Additional annotations that you require for the Service object | `map(string)` | `{}` | no |
| <a name="input_service_labels"></a> [service\_labels](#input\_service\_labels) | (optional) Additional labels that you require for the Serivce object | `map(string)` | `{}` | no |
| <a name="input_service_spec"></a> [service\_spec](#input\_service\_spec) | All possible arguments for the [Service spec](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1), the only required parameters are `ports = [{ "port" = <port-number> }]` | <pre>list(object({<br>    allocate_load_balancer_node_ports = optional(bool)<br>    cluster_ip                        = optional(string)<br>    cluster_ips                       = optional(list(string))<br>    external_ips                      = optional(list(string))<br>    external_name                     = optional(string)<br>    external_traffic_policy           = optional(string)<br>    internal_traffic_policy           = optional(string)<br>    load_balancer_ip                  = optional(string)<br>    session_affinity                  = optional(string)<br>    selector                          = optional(map(string))<br>    type                              = optional(string)<br>    ports = list(object({<br>      name        = optional(string)<br>      port        = number<br>      target_port = optional(number)<br>      protocol    = optional(string)<br>      node_port   = optional(number)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_target_cpu_utilization_percentage"></a> [target\_cpu\_utilization\_percentage](#input\_target\_cpu\_utilization\_percentage) | (optional) Target average CPU utilization (represented as a percentage of requested CPU) over all the pods | `string` | `null` | no |


<!-- END_TF_DOCS -->
