output "config_data" {
  value = local.configmap_data
  description = "Assist in debugging"
}

output "config_binary_data" {
  value = local.configmap_binary_data
  description = "Assist in debugging"
}

output "sercret_binary_data" {
  value = local.secret_binary_data
  description = "Assist in debugging"
}
