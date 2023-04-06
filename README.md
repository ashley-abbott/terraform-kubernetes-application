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

	 # Optional variables
	 automount_service_account_token  = true
	 commit_before_sha  = "00000000"
	 commit_short_sha  = "00000001"
	 common_annotations  = {}
	 common_labels  = {}
	 config_annotations  = {}
	 config_labels  = {}
	 configmap_binary_data  = {}
	 configmap_data  = {}
	 deployment_annotations  = {}
	 deployment_labels  = {}
	 deployment_spec  = {}
	 enable_green_deployment  = false
	 hpa_annotations  = {}
	 hpa_labels  = {}
	 hpa_spec  = {}
	 ingress_annotations  = {}
	 ingress_labels  = {}
	 ingress_spec  = null
	 namespace  = "default"
	 node_affinity  = {}
	 persistent_volume_claim_annotations  = {}
	 persistent_volume_claim_labels  = {}
	 persistent_volume_claim_spec  = []
	 pod_affinity  = {}
	 pod_anti_affinity  = {}
	 pod_disruption_budget_annotations  = {}
	 pod_disruption_budget_labels  = {}
	 pod_disruption_budget_spec  = {}
	 revert_green  = false
	 secret_annotations  = {}
	 secret_binary_data  = {}
	 secret_data  = {}
	 secret_labels  = {}
	 service_account_image_pull_secret  = []
	 service_annotations  = {}
	 service_labels  = {}
	 service_selector  = null
	 service_spec  = null
	 statefulset_annotations  = {}
	 statefulset_labels  = {}
	 statefulset_spec  = {}
	 switch_traffic  = false
	 use_existing_k8s_sa  = false
}
```

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/config_map) | resource |
| [kubernetes_deployment_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/deployment_v1) | resource |
| [kubernetes_horizontal_pod_autoscaler_v2.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/horizontal_pod_autoscaler_v2) | resource |
| [kubernetes_ingress_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/ingress_v1) | resource |
| [kubernetes_persistent_volume_claim_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/persistent_volume_claim_v1) | resource |
| [kubernetes_pod_disruption_budget_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/pod_disruption_budget_v1) | resource |
| [kubernetes_secret_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.application_sa_token](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/secret_v1) | resource |
| [kubernetes_service_account_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/service_account_v1) | resource |
| [kubernetes_service_v1.application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/service_v1) | resource |
| [kubernetes_stateful_set_v1.stateful_application](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/stateful_set_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the application being deployed, this will be used across multiple resources | `string` | n/a | yes |
| <a name="input_automount_service_account_token"></a> [automount\_service\_account\_token](#input\_automount\_service\_account\_token) | (optional) Whether to enable automatic mounting of the service account token | `bool` | `true` | no |
| <a name="input_commit_before_sha"></a> [commit\_before\_sha](#input\_commit\_before\_sha) | n/a | `string` | `"00000000"` | no |
| <a name="input_commit_short_sha"></a> [commit\_short\_sha](#input\_commit\_short\_sha) | Initial work for blue/green | `string` | `"00000001"` | no |
| <a name="input_common_annotations"></a> [common\_annotations](#input\_common\_annotations) | (optional) Common annotations that you require across all objects being created | `map(any)` | `{}` | no |
| <a name="input_common_labels"></a> [common\_labels](#input\_common\_labels) | (optional) Common labels that you require across all objects being created | `map(any)` | `{}` | no |
| <a name="input_config_annotations"></a> [config\_annotations](#input\_config\_annotations) | (optional) Additional annotations that you require for the ConfigMap object(s) | `map(string)` | `{}` | no |
| <a name="input_config_labels"></a> [config\_labels](#input\_config\_labels) | (optional) Additional labels that you require for the ConfigMap object(s) | `map(string)` | `{}` | no |
| <a name="input_configmap_binary_data"></a> [configmap\_binary\_data](#input\_configmap\_binary\_data) | (optional) Conditionally create one or more ConfigMaps, keys from both `configmap_data` and `configmap_binary_data` will be merged allowing to specify only one of the two variables if so desired. Values specified in this variable will be base64 encoded before being passed to the K8s API | `any` | `{}` | no |
| <a name="input_configmap_data"></a> [configmap\_data](#input\_configmap\_data) | (optional) Conditionally create one or more ConfigMaps, keys from both `configmap_data` and `configmap_binary_data` will be merged allowing to specify only one of the two variables if so desired | `any` | `{}` | no |
| <a name="input_deployment_annotations"></a> [deployment\_annotations](#input\_deployment\_annotations) | (optional) Additional annotations that you require for the Deployment object | `map(string)` | `{}` | no |
| <a name="input_deployment_labels"></a> [deployment\_labels](#input\_deployment\_labels) | (optional) Additional labels that you require for the Deployment object | `map(string)` | `{}` | no |
| <a name="input_deployment_spec"></a> [deployment\_spec](#input\_deployment\_spec) | Includes both Replication Controller Spec and Pod Spec, this variable is set to type `any` to allow as many or as few attributes as you desire, defaulting to the resource defaults when omitted.<br><br>The attribute `strategy { type }` is defined as `strategy_type` for brevity see [k8s\_deployment.tf](./k8s\_deployment.tf#L31)<br><br>For reference: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment#spec | `any` | `{}` | no |
| <a name="input_enable_green_deployment"></a> [enable\_green\_deployment](#input\_enable\_green\_deployment) | n/a | `bool` | `false` | no |
| <a name="input_hpa_annotations"></a> [hpa\_annotations](#input\_hpa\_annotations) | (optional) Additional annotations that you require for the Horizontal Pod Autoscaler object | `map(string)` | `{}` | no |
| <a name="input_hpa_labels"></a> [hpa\_labels](#input\_hpa\_labels) | (optional) Additional labels that you require for the Horizontal Pod Autoscaler object | `map(string)` | `{}` | no |
| <a name="input_hpa_spec"></a> [hpa\_spec](#input\_hpa\_spec) | (optional) | `any` | `{}` | no |
| <a name="input_ingress_annotations"></a> [ingress\_annotations](#input\_ingress\_annotations) | (optional) Additional annotations that you require for the Ingress object | `map(string)` | `{}` | no |
| <a name="input_ingress_labels"></a> [ingress\_labels](#input\_ingress\_labels) | (optional) Additional labels that you require for the Ingress object | `map(string)` | `{}` | no |
| <a name="input_ingress_spec"></a> [ingress\_spec](#input\_ingress\_spec) | (optional) Conditionally create an Ingress object, if this variable isn't populated the Ingress is skipped | `any` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace in which you want all your resources to be deployed | `string` | `"default"` | no |
| <a name="input_node_affinity"></a> [node\_affinity](#input\_node\_affinity) | n/a | `any` | `{}` | no |
| <a name="input_persistent_volume_claim_annotations"></a> [persistent\_volume\_claim\_annotations](#input\_persistent\_volume\_claim\_annotations) | (optional) Additional labels that you require for the PersistentVolumeClaim object | `map(string)` | `{}` | no |
| <a name="input_persistent_volume_claim_labels"></a> [persistent\_volume\_claim\_labels](#input\_persistent\_volume\_claim\_labels) | (optional) Additional labels that you require for the PersistentVolumeClaim object | `map(string)` | `{}` | no |
| <a name="input_persistent_volume_claim_spec"></a> [persistent\_volume\_claim\_spec](#input\_persistent\_volume\_claim\_spec) | (optional) Conditionally create a [PersistentVolumeClaim](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim_v1#spec), if this variable isn't populated the PVC is skipped | <pre>list(object({<br>    access_modes       = optional(list(string))<br>    storage_request    = optional(string)<br>    storage_class_name = optional(string)<br>    volume_name        = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_pod_affinity"></a> [pod\_affinity](#input\_pod\_affinity) | n/a | `any` | `{}` | no |
| <a name="input_pod_anti_affinity"></a> [pod\_anti\_affinity](#input\_pod\_anti\_affinity) | n/a | `any` | `{}` | no |
| <a name="input_pod_disruption_budget_annotations"></a> [pod\_disruption\_budget\_annotations](#input\_pod\_disruption\_budget\_annotations) | (optional) Additional annotations that you require for the PodDisruptionBudget object | `map(string)` | `{}` | no |
| <a name="input_pod_disruption_budget_labels"></a> [pod\_disruption\_budget\_labels](#input\_pod\_disruption\_budget\_labels) | (optional) Additional labels that you require for the PodDisruptionBudget object | `map(string)` | `{}` | no |
| <a name="input_pod_disruption_budget_spec"></a> [pod\_disruption\_budget\_spec](#input\_pod\_disruption\_budget\_spec) | (optional) describe your variable | `any` | `{}` | no |
| <a name="input_revert_green"></a> [revert\_green](#input\_revert\_green) | n/a | `bool` | `false` | no |
| <a name="input_secret_annotations"></a> [secret\_annotations](#input\_secret\_annotations) | (optional) Additional annotations that you require for the Secret object(s) | `map(string)` | `{}` | no |
| <a name="input_secret_binary_data"></a> [secret\_binary\_data](#input\_secret\_binary\_data) | (optional) Conditionally create one or more Secrets, keys from both `secret_data` and `secret_binary_data` will be merged allowing to specify only one of the two variables if so desired. Values specified in this variable will be base64 encoded before being passed to the K8s API | `any` | `{}` | no |
| <a name="input_secret_data"></a> [secret\_data](#input\_secret\_data) | (optional) Conditionally create one or more Secrets, keys from both `secret_data` and `secret_binary_data` will be merged allowing to specify only one of the two variables if so desired | `any` | `{}` | no |
| <a name="input_secret_labels"></a> [secret\_labels](#input\_secret\_labels) | (optional) Additional labels that you require for the Secret object(s) | `map(string)` | `{}` | no |
| <a name="input_service_account_image_pull_secret"></a> [service\_account\_image\_pull\_secret](#input\_service\_account\_image\_pull\_secret) | (optional) A list of references to secrets in the same namespace to use for pulling any images in pods that reference this Service Account | `list(any)` | `[]` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | (optional) Additional annotations that you require for the Service object | `map(string)` | `{}` | no |
| <a name="input_service_labels"></a> [service\_labels](#input\_service\_labels) | (optional) Additional labels that you require for the Serivce object | `map(string)` | `{}` | no |
| <a name="input_service_selector"></a> [service\_selector](#input\_service\_selector) | value | `map(string)` | `null` | no |
| <a name="input_service_spec"></a> [service\_spec](#input\_service\_spec) | All possible arguments for the [Service spec](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1), the only required parameters are `ports = [{ "port" = <port-number> }]` | `any` | `null` | no |
| <a name="input_statefulset_annotations"></a> [statefulset\_annotations](#input\_statefulset\_annotations) | (optional) Additional annotations that you require for the StatefulSet object | `map(string)` | `{}` | no |
| <a name="input_statefulset_labels"></a> [statefulset\_labels](#input\_statefulset\_labels) | (optional) Additional labels that you require for the StatefulSet object | `map(string)` | `{}` | no |
| <a name="input_statefulset_spec"></a> [statefulset\_spec](#input\_statefulset\_spec) | (optional) describe your variable | `any` | `{}` | no |
| <a name="input_switch_traffic"></a> [switch\_traffic](#input\_switch\_traffic) | n/a | `bool` | `false` | no |
| <a name="input_use_existing_k8s_sa"></a> [use\_existing\_k8s\_sa](#input\_use\_existing\_k8s\_sa) | (optional) Boolean used to control whether to utilise a pre existing K8s service account | `bool` | `false` | no |


<!-- END_TF_DOCS -->
