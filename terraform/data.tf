data "google_compute_regions" "available" {
}

locals {
  # Creative way to obtain project id without enabling Cloud Resource Manager API
  project_id = split(".", split("@", google_service_account.compute.email)[1])[0]
}