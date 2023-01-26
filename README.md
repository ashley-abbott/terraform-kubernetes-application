# terraform-kubernetes-application

This code is designed with Helm in mind to create a generic K8s application

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
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
	 deployment_strategy  = {
  "rolling_update": [
    {}
  ],
  "type": null
}
	 hpa_annotations  = {}
	 hpa_labels  = {}
	 hpa_spec  = null
	 ingress_annotations  = {}
	 ingress_labels  = {}
	 ingress_spec  = null
	 max_replicas  = 1
	 min_replicas  = null
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
| [kubernetes_ingress.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/ingress) | resource |
| [kubernetes_secret.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/secret) | resource |
| [kubernetes_service_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/service_v1) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | (optional) describe your variable | `string` | n/a | yes |
| <a name="input_common_annotations"></a> [common\_annotations](#input\_common\_annotations) | (optional) describe your variable | `map(any)` | `{}` | no |
| <a name="input_common_labels"></a> [common\_labels](#input\_common\_labels) | (optional) describe your variable | `map(any)` | `{}` | no |
| <a name="input_config_annotations"></a> [config\_annotations](#input\_config\_annotations) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_config_labels"></a> [config\_labels](#input\_config\_labels) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_configmap_binary_data"></a> [configmap\_binary\_data](#input\_configmap\_binary\_data) | (optional) describe your variable | `any` | `{}` | no |
| <a name="input_configmap_data"></a> [configmap\_data](#input\_configmap\_data) | (optional) describe your variable | `any` | `{}` | no |
| <a name="input_deployment_annotations"></a> [deployment\_annotations](#input\_deployment\_annotations) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_deployment_labels"></a> [deployment\_labels](#input\_deployment\_labels) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_deployment_spec"></a> [deployment\_spec](#input\_deployment\_spec) | (optional) describe your variable | `any` | <pre>[<br>  {}<br>]</pre> | no |
| <a name="input_deployment_strategy"></a> [deployment\_strategy](#input\_deployment\_strategy) | (optional) describe your variable | <pre>object({<br>    type           = optional(string)<br>    rolling_update = optional(list(map(string)))<br>  })</pre> | <pre>{<br>  "rolling_update": [<br>    {}<br>  ],<br>  "type": null<br>}</pre> | no |
| <a name="input_hpa_annotations"></a> [hpa\_annotations](#input\_hpa\_annotations) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_hpa_labels"></a> [hpa\_labels](#input\_hpa\_labels) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_hpa_spec"></a> [hpa\_spec](#input\_hpa\_spec) | (optional) describe your variable | `any` | `null` | no |
| <a name="input_ingress_annotations"></a> [ingress\_annotations](#input\_ingress\_annotations) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_ingress_labels"></a> [ingress\_labels](#input\_ingress\_labels) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_ingress_spec"></a> [ingress\_spec](#input\_ingress\_spec) | (optional) describe your variable | `any` | `null` | no |
| <a name="input_max_replicas"></a> [max\_replicas](#input\_max\_replicas) | (optional) describe your variable | `number` | `1` | no |
| <a name="input_min_replicas"></a> [min\_replicas](#input\_min\_replicas) | (optional) describe your variable | `number` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (optional) describe your variable | `string` | n/a | yes |
| <a name="input_secret_annotations"></a> [secret\_annotations](#input\_secret\_annotations) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_secret_binary_data"></a> [secret\_binary\_data](#input\_secret\_binary\_data) | (optional) describe your variable | `any` | `{}` | no |
| <a name="input_secret_data"></a> [secret\_data](#input\_secret\_data) | (optional) describe your variable | `any` | `{}` | no |
| <a name="input_secret_labels"></a> [secret\_labels](#input\_secret\_labels) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_service_labels"></a> [service\_labels](#input\_service\_labels) | (optional) describe your variable | `map(string)` | `{}` | no |
| <a name="input_service_spec"></a> [service\_spec](#input\_service\_spec) | value | <pre>list(object({<br>    allocate_load_balancer_node_ports = optional(bool)<br>    cluster_ip                        = optional(string)<br>    cluster_ips                       = optional(list(string))<br>    external_ips                      = optional(list(string))<br>    external_name                     = optional(string)<br>    external_traffic_policy           = optional(string)<br>    internal_traffic_policy           = optional(string)<br>    load_balancer_ip                  = optional(string)<br>    session_affinity                  = optional(string)<br>    selector                          = optional(map(string))<br>    type                              = optional(string)<br>    ports = list(object({<br>      name        = optional(string)<br>      port        = number<br>      target_port = optional(number)<br>      protocol    = optional(string)<br>      node_port   = optional(number)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_target_cpu_utilization_percentage"></a> [target\_cpu\_utilization\_percentage](#input\_target\_cpu\_utilization\_percentage) | (optional) describe your variable | `string` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_binary_data"></a> [config\_binary\_data](#output\_config\_binary\_data) | Assist in debugging |
| <a name="output_config_data"></a> [config\_data](#output\_config\_data) | Assist in debugging |
| <a name="output_sercret_binary_data"></a> [sercret\_binary\_data](#output\_sercret\_binary\_data) | Assist in debugging |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->