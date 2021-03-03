data "template_file" "fleet_agent_values" {
  template = file("${path.module}/templates/fleet-agent-values.yaml.tmpl")
  for_each    = google_container_cluster.mission_control
  vars = {
    endpoint  = each.value.endpoint
    cluster_ca_certificate = each.value.master_auth[0].cluster_ca_certificate
  }
}

resource "local_file" "fleet_agent_values" {
    for_each = data.template_file.fleet_agent_values
    content     = each.value.rendered
    filename = "${path.module}/fleet-agent-values.yaml"
    file_permission = "0600"
}
