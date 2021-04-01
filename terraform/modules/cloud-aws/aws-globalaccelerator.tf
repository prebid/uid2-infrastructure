resource "aws_globalaccelerator_accelerator" "uid2" {
  for_each = length(var.regions) > 0 ? toset([var.global_resources_region]) : toset([]) # If at least one aws region specified, we need to create global accellerator
  name            = "uid2"
  ip_address_type = "IPV4"
  enabled         = true
}

resource "aws_globalaccelerator_listener" "uid2" {
  for_each = length(var.regions) > 0 ? toset([var.global_resources_region]) : toset([])
  accelerator_arn = aws_globalaccelerator_accelerator.uid2[each.key].id
  protocol        = "TCP"
  client_affinity = "NONE"

  port_range {
    from_port = 80
    to_port   = 80
  }
  port_range {
    from_port = 443
    to_port   = 443
  }
}

resource "google_dns_record_set" "uid2-0_aws" {
  name = "aws.${data.google_dns_managed_zone.uid2-0.dns_name}"
  type = "A"
  ttl  = 600
  managed_zone =  data.google_dns_managed_zone.uid2-0.name
  rrdatas = aws_globalaccelerator_accelerator.uid2[var.global_resources_region].ip_sets[0].ip_addresses # IPV4 only
}

resource "local_file" "ga" {
    count = length(var.regions) > 0 ? 1 : 0
    content     = templatefile("${path.module}/templates/ga.tf.tpl", { regions = var.regions, listener_arn = aws_globalaccelerator_listener.uid2[var.global_resources_region].id })
    filename = "${path.root}/../stage2/ga_generated.tf"
    file_permission = "0644"
}

