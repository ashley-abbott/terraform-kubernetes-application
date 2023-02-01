module "my_k8s_application" {
  source    = "../../"
  app_name  = "nginx"
  namespace = "dev1"

  deployment_spec = [{
    podspec = { containers = [{ image = "nginx:latest" }] }
  }]

  service_spec = [{
    ports = [{ "port" = 80 }]
  }]
}
