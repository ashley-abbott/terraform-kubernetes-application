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

  deployment_spec = {
    podspec = { containers = [{ image = "nginx:latest" }] }
  }

  service_spec = {
    ports = [{ "port" = 80 }]
  }

  secret_binary_data = {
    artifactory = {
      type = "kubernetes.io/dockerconfigjson"
      ".dockerconfigjson" = jsonencode(
        {
          "auths" : {
            "example.docker-repo.net" : {
              "auth" : "dXNlcm5hbWU6cmFuZG9tc3RyaW5nCg=="
            }
          }
        }
      )
    }
  }
}
