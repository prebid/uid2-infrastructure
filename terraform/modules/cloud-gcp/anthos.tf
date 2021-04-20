resource "google_gke_hub_membership" "membership" {
  for_each = google_container_cluster.mission_control
  membership_id = each.value.name
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${each.value.id}"
    }
  }
  description = "Mission control for UID2"
  provider    = google-beta
  depends_on  = [google_project_service.apis]
}
