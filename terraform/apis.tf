resource "google_project_service" "cloudresourcemanager" {
  project = local.project_id
  service = "cloudresourcemanager.googleapis.com"
}
