resource "random_pet" "eks" {
  keepers = {
    # Generate a new pet name each time something changes in environment or region
    cluster_name = "${var.region}${var.environment}"
  }
}
locals {
  cluster_name = "${var.environment}-${var.region}-${random_pet.eks.id}"
}
