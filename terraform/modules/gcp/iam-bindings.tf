resource "google_project_iam_binding" "autoneg" {
  role = google_project_iam_custom_role.autoneg.name
  members = [
    module.workload_identity_autoneg-system.gcp_service_account_fqn
  ]
}
