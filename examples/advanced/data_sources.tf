data "google_client_config" "provider" {}

data "google_container_cluster" "dev-cluster" {
  name     = "development"
  location = var.region
  depends_on = [
    google_container_cluster.dev-cluster
  ]
}
