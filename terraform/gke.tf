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

}
