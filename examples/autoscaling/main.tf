module "my_k8s_application" {
  source   = "../../"
  app_name = "nginx"

  deployment_spec = {
    podspec = { containers = [{ image = "nginx:latest" }] }
  }

  service_spec = {
    ports = [
      {
        app_protocol = "http"
        port         = 80
      }
    ]
  }

  hpa_spec = {
    max_replicas = 10
    scale_target_ref = {
      name = "nginx"
    }
    metrics = [
      {
        type = "External"
        external = {
          name = "pubsub.googleapis.com|subscription|num_undelivered_messages"
          selector = {
            match_labels = {
              "resource.labels.subscription_id" = "generic-subscription"
            }
          }
          average_value = 1000
          type          = "AverageValue"
        }
      }
    ]
    behavior = {
      scale_up = {
        stabilization_window_seconds = 300
        select_policy                = "Min"
        policies = [
          {
            period_seconds = 180
            type           = "Percent"
            value          = 100
          },
          {
            period_seconds = 600
            type           = "Pods"
            value          = 5
          }
        ]
      }
    }
  }
}
