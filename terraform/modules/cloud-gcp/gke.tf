resource "local_file" "eks_modules" {
  content         = templatefile("${path.module}/templates/gke.tf.tpl", { regions = var.regions, environment = var.environment, compute_service_account = google_service_account.compute.email })
  filename        = "${path.root}/../stage2/gke_generated.tf"
  file_permission = "0644"
}
