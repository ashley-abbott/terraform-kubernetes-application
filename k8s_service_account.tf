resource "kubernetes_service_account_v1" "application" {
  for_each = local.service_accounts

  dynamic "metadata" {
    for_each = local.standard_metadata

    content {
      name      = each.key
      namespace = metadata.value["namespace"]
    }
  }

  dynamic "image_pull_secret" {
    for_each = var.service_account_image_pull_secret

    content {
      name = image_pull_secret.value
    }
  }

  secret {
    name = "${each.key}-sa-token"
  }

  automount_service_account_token = var.automount_service_account_token
}

resource "kubernetes_secret_v1" "application_sa_token" {
  for_each = local.service_accounts

  dynamic "metadata" {
    for_each = local.standard_metadata

    content {
      name      = "${each.key}-sa-token"
      namespace = metadata.value["namespace"]
      annotations = {
        "kubernetes.io/service-account.name" = each.key
      }
    }
  }

  type = "kubernetes.io/service-account-token"
}
