resource "google_project_services" "apis" {
  services = ["cloudresourcemanager.googleapis.com", "servicemanagement.googleapis.com"]
}
