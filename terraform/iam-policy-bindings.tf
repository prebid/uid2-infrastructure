resource "google_project_iam_binding" "project" {
  project = local.project_id
  role    = google_project_iam_custom_role.autoneg.id

  members = [
    module.workload_identity_autoneg-system.gcp_service_account_fqn,
  ]
  depends_on = [
    google_project_service.apis
  ]
}
