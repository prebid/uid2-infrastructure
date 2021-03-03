data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconfig.yaml.tmpl")
  for_each    = merge(google_container_cluster.primary, google_container_cluster.mission_control)
  vars = {
    token = data.google_client_config.provider.access_token
    endpoint  = each.value.endpoint
    cluster_ca_certificate = each.value.master_auth[0].cluster_ca_certificate
    name = each.value.name
  }
}

resource "local_file" "kubeconfig" {
    for_each = data.template_file.kubeconfig
    content     = each.value.rendered
    filename = "${path.module}/kubecontext-${each.key}.yaml"
    file_permission = "0600"
}