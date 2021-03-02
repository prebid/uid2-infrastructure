resource "google_container_cluster" "primary" {
  for_each = toset(var.regions)
  name     = "uid2-${each.key}"
  # Regional master
  location = each.key
  remove_default_node_pool = true
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
    service_account = google_service_account.compute.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum = 3
      maximum = 30
    }
  }
  depends_on = [ google_service_account_iam_binding.admin-account-iam ]
}
