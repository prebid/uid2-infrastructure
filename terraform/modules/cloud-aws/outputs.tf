output "ga_listener_arn" {
  value = aws_globalaccelerator_listener.uid2[var.global_resources_region].id
}
