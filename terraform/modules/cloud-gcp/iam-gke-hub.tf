resource "google_service_account" "gke_hub_sa" {
  account_id   = "gke-hub-sa"
  display_name = "Service Account for GKE Hub Registration"
  depends_on   = [google_project_service.apis]
}

resource "google_project_iam_member" "gke_hub_member" {
  role   = "roles/gkehub.connect"
  member = "serviceAccount:${google_service_account.gke_hub_sa.email}"
}
