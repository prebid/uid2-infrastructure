resource "local_file" "kubeconfig" {
  count             = 0
  sensitive_content = templatefile("${path.module}/templates/kubeconfig.yaml.tmpl", { token = data.google_client_config.provider.access_token, endpoint = google_container_cluster.this.endpoint, cluster_ca_certificate = google_container_cluster.this.master_auth[0].cluster_ca_certificate, name = google_container_cluster.this.name })
  filename          = "${path.root}/../outputs/gcp-kubecontext-${google_container_cluster.this.name}.yaml"
  file_permission   = "0600"
}
