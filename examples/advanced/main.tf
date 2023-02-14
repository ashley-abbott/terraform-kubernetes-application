module "my_k8s_application" {
  source    = "../../"
  app_name  = "nginx"
  namespace = "default"

  deployment_spec = [{
    replicas = 2
    podspec = {
      volumes = [
        {
          name = "credentials"
          config_map = {
            name = "nginx-credentials-config"
          }
        }
      ]
      init_containers = [
        {
          name  = "init"
          image = "alpine:latest"
        }
      ]
      containers = [
        {
          image = "nginx:latest"
          liveness_probe = {
            type = "tcp_socket"
            port = "80"
          }
          readiness_probe = {
            type = "http_get"
            port = "80"
            path = "/"
          }
          env = [
            {
              name = "DBPASSWORD"
              value_from = {
                secret_key_ref = {
                  key = "db_password"
                  name = "nginx-database"
                }
              }
            }
          ]
          env_from = [
            {
              config_map_ref = {
                name = "nginx-environment-config"
              }
            }
          ]
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
          volume_mount = [
            {
              name = "credentials"
              mount_path = "/tmp/credentials"
            }
          ]
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
        "port" = 80,
        "app_protocol" = "http"
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
    credentials = {
      username = "admin"
      password = "letmein"
    },
    environment = {
      firstEnv  = "one"
      secondEnv = "two"
      thirdEnv  = "three"
    }
  }

  secret_data = {
    database = {
      db_host  = "dbhost:3306"
    }
  }

  secret_binary_data = {
    database = {
      db_password = "changeme"
    }
  }
}
