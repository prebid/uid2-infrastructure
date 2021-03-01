resource "google_service_account" "compute" {
  account_id   = "uid2-compute"
  display_name = "Dummy service account for GKE compute nodes"
}
