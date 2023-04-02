data "google_client_config" "provider" {}

data "google_container_cluster" "dev-cluster" {
  name     = "development"
  location = "europe-west2-a"
  depends_on = [
    google_container_cluster.dev-cluster
  ]
}

module "my_k8s_application" {
  source    = "../../"
  app_name  = "nginx"
  namespace = "default"

  deployment_spec = [{
    podspec = { containers = [{ image = "nginx:latest" }] }
  }]

  service_spec = [{
    ports = [{ "port" = 80 }]
  }]
}
