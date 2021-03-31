resource "random_pet" "gke" {
  keepers = {
    # Generate a new pet name each time something changes in environment or region
    cluster_name = "${var.region}${var.environment}"
  }
}
locals {
  cluster_name = "${var.environment}-${var.region}-${random_pet.gke.id}"

  # Creative way to obtain project id without enabling Cloud Resource Manager API
  project_id = split(".", split("@", var.compute_service_account)[1])[0]
}
