resource "random_pet" "gke_clusters" {
  for_each = toset(var.regions)
}

locals {
  region_to_pet = {for k, v in random_pet.gke_clusters : k => v.id}
}

resource "local_file" "gke_modules" {
  content = templatefile("${path.module}/templates/gke.tf.tpl", {
    regions                 = var.regions,
    pets                    = formatlist("${var.environment}-%s-%s", keys(local.region_to_pet), values(local.region_to_pet))
    environment             = var.environment,
    compute_service_account = google_service_account.compute.email,
    iap_brand               = google_iap_brand.mission_control.name,
    mission_control_ips     = google_compute_address.mission_control.*.address
  })
  filename        = "${path.root}/../stage2/gke_generated.tf"
  file_permission = "0644"
}
