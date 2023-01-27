module "my_k8s_application" {
  source = "../"
  app_name = "nginx"
  namespace = "dev1"

  deployment_spec = [{
    replicas = 2
    podspec = {
      init_containers = [
        {
          name  = "init"
          image = "alpine:latest"
        }
      ]
      containers = [
        {
          image = "nginx:latest"
          resources = [{
            limits = {
              cpu    = "100m"
              memory = "100M"
            }
            requests = {
              cpu    = "50m"
              memory = "50M"
            }
          }]
        },
        {
          name  = "sidecar"
          image = "yauritux/busybox-curl:latest"
          args  = ["/bin/sh", "-c", "sleep infinity"]
          env = [
            {
              name  = "HELLO"
              value = "WORLD"
            }
          ]
        }
      ]
    }
  }]

  service_spec = [{
    ports = [
    {
      "port" = 80
    },
    {
      "name"        = "something"
      "port"        = 9000,
      "target_port" = 9002,
      "protocol"    = "UDP"
    }]
  }]

  common_labels = {
    dept    = "Avengers"
    part-of = "ENG"
    name    = "awesome-service"
  }

  common_annotations = {
    "app.kubernetes.io/part-of" = "ENG"
    "app.kubernetes.io/name"    = "awesome-service"
  }

  configmap_data = {
    database = {
      api_host = "myhost:443"
      db_host  = "dbhost:3306"
    },
    credentials = {
      username = "admin"
      password = "letmein"
    }
  }

  configmap_binary_data = {
    database = {
      db_password = "changeme"
    }
  }
}
