provider "helm" {
  kubernetes {
    host     = google_container_cluster.this.endpoint
    cluster_ca_certificate = base64decode(google_container_cluster.this.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.provider.access_token
  }
}

resource "google_container_cluster" "this" {
  name     = local.cluster_name
  project  = local.project_id
  # Regional master
  location = var.region
  remove_default_node_pool = false
  initial_node_count       = 1
  ip_allocation_policy {
  }
  private_cluster_config {
    enable_private_nodes = false
    enable_private_endpoint = false
  }
  release_channel {
    channel = var.environment == "prod" ? "REGULAR" : "RAPID"
  }
  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = var.compute_service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  workload_identity_config {
  identity_namespace = "${local.project_id}.svc.id.goog"
  }
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum = 3
      maximum = 30
    }
    resource_limits {
      resource_type = "memory"
      minimum = 24
      maximum = 240
    }
  }
}
