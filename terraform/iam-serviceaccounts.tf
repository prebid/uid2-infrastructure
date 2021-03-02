# Do not use default compute service account as it has excessive permissions
resource "google_service_account" "compute" {
  account_id   = "uid2-compute"
  display_name = "Dummy service account for GKE compute nodes"
}

resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = google_service_account.compute.name
  role               = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${google_service_account.terraform.email}",
  ]
}