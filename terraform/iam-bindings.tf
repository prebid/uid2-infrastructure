resource "google_iap_web_backend_service_iam_binding" "autoneg" {
  web_backend_service = google_compute_backend_service.uid2_server.name
  role = google_project_iam_custom_role.autoneg.name
  members = [
    module.workload_identity_autoneg-system.gcp_service_account_fqn
  ]
}
