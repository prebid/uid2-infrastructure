data "google_compute_regions" "available" {
}
data "google_project" "project" {
  depends_on = [ google_project_service.cloudresourcemanager ]
}