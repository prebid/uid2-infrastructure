resource "google_gke_hub_membership" "membership" {
  membership_id = google_container_cluster.this.name
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.this.id}"
    }
  }
  description = google_container_cluster.this.name
  provider    = google-beta
}
