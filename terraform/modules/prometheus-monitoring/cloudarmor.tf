resource "google_compute_security_policy" "thanos" {
  count = var.is_global ? 1 : 0
  name = "thanos-ingress"

  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = formatlist("%s/32", var.mission_control_ips)
      }
    }
    description = "Allow access from mission-control NAT IPs"
  }

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule, deny all"
  }
}
