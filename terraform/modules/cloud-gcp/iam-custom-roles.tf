resource "google_project_iam_custom_role" "autoneg" {
  role_id     = "autoneg"
  title       = "Autoneg service"
  description = "Minimal permissions for autoneg service"
  permissions = ["compute.backendServices.get", "compute.backendServices.update", "compute.networkEndpointGroups.use", "compute.healthChecks.useReadOnly"]
  depends_on  = [google_project_service.apis]
}
