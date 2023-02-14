# provider "kubernetes" {
#   host  = "https://${data.google_container_cluster.dev-cluster.endpoint}"
#   token = data.google_client_config.provider.access_token
#   cluster_ca_certificate = base64decode(
#     data.google_container_cluster.dev-cluster.master_auth[0].cluster_ca_certificate,
#   )
# }

provider "kubernetes" {
  config_path = "~/.kube/config"
}
