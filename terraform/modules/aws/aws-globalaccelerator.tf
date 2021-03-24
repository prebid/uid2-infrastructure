resource "aws_globalaccelerator_accelerator" "uid2" {
  for_each = length(var.regions) > 0 ? toset([var.regions[0]]) : toset([]) # If at least one aws region specified, we need to create global accellerator
  name            = "uid2"
  ip_address_type = "IPV4"
  enabled         = true
}

resource "aws_globalaccelerator_listener" "uid2" {
  for_each = length(var.regions) > 0 ? toset([var.regions[0]]) : toset([])
  accelerator_arn = aws_globalaccelerator_accelerator.uid2[each.key].id
  protocol        = "TCP"
  client_affinity = "NONE"

  port_range {
    from_port = 80
    to_port   = 80
  }
}
