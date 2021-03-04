resource "local_file" "kubeconfig" {
  for_each          = merge(google_container_cluster.primary, google_container_cluster.mission_control)
  sensitive_content = templatefile("${path.module}/templates/kubeconfig.yaml.tmpl", { token = data.google_client_config.provider.access_token, endpoint = each.value.endpoint, cluster_ca_certificate = each.value.master_auth[0].cluster_ca_certificate, name = each.value.name })
  filename          = "${path.module}/kubecontext-${each.key}.yaml"
  file_permission   = "0600"
}