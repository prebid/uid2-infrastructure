resource "random_pet" "gke_clusters" {
  for_each = toset(var.regions)
}

resource "local_file" "gke_modules" {
  content = templatefile("${path.module}/templates/gke.tf.tpl", {
    regions                 = var.regions,
    environment             = var.environment,
    compute_service_account = google_service_account.compute.email,
    iap_brand               = google_iap_brand.mission_control.name,
    mission_control_ips     = google_compute_address.mission_control.*.address
  })
  filename        = "${path.root}/../stage2/gke_generated.tf"
  file_permission = "0644"
}
