module "my_k8s_application" {
  source    = "../../"
  app_name  = "nginx"
  namespace = "dev1"

  deployment_spec = {
    podspec = { containers = [{ image = "nginx:latest" }] }
  }

  service_spec = [{
    ports = [{ "port" = 80 }]
  }]

  ingress_spec = [{
    ingress_class_name = "nginx"
    rules = [
      {
        host = "example.me"
        paths = [
          {
            path = "/app1/*"
            backend = [{
              service_port = 8080
              service_name = "my-service1"
            }]
          },
          {
            path = "/app2/*"
            backend = [{
              service_port = 8443
              service_name = "my-service2"
            }]
          }
        ]
      },
      {
        host = "anotherexample.com"
        paths = [{
          path      = "/blog/*"
          path_type = "Prefix"
          backend = [{
            service_port = 9000
            service_name = "my-service"
          }]
        }]
      }
    ]
  }]
}
