data "google_project" "this" {
  project_id = var.project_id
}

locals {
  project_number = data.google_project.this.number
}
