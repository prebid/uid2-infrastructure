locals {
  # Creative way to obtain project id without enabling Cloud Resource Manager API
  project_id = split(".", split("@", var.compute_service_account)[1])[0]
}
