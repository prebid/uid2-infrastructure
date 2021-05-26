data "google_client_config" "provider" {
}

data "google_project" "this" {
  project_id = local.project_id
}