provider "google" {
  project = "gke-playground-295816"
  region  = "europe-west2"
}

provider "google-beta" {
  project = "gke-playground-295816"
  region  = "europe-west2"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.dev-cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.dev-cluster.master_auth[0].cluster_ca_certificate,
  )
}
