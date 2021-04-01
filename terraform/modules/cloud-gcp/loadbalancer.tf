locals {
  # Exposed *pod* ports for services we need to expose
  health_check_k8s_destination_ports = ["8000", "8080", "80"]
  
  ssl_domains = [
      trimsuffix(data.google_dns_managed_zone.uid2-0.dns_name, "."),
      trimsuffix("gcp.${data.google_dns_managed_zone.uid2-0.dns_name}", "."),
  ]
}

resource "random_pet" "cert" {
  keepers = {
    # Generate a new pet name each time something changes in environment or region
    ssl_domains = join(",", local.ssl_domains)
  }
}

# IP reservation
resource "google_compute_global_address" "uid2_ip_1" {
  name = "uid2-1-${var.environment}"
}

resource "google_compute_global_address" "uid2_ip_2" {
  name = "uid2-2-${var.environment}"
}

resource "google_dns_record_set" "uid2-0_root" {
  name = "gcp.${data.google_dns_managed_zone.uid2-0.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone =  data.google_dns_managed_zone.uid2-0.name
  rrdatas = [ google_compute_global_address.uid2_ip_1.address, google_compute_global_address.uid2_ip_2.address ]
}

# SSL Cert
resource "google_compute_managed_ssl_certificate" "uid2-v1" {
  name     = random_pet.cert.id
  managed {
    domains = local.ssl_domains
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Forwarding Rules
resource "google_compute_global_forwarding_rule" "uid2_https_1" {
  name       = "uid2-https-rule-1"
  target     = google_compute_target_https_proxy.uid2_https_proxy.self_link
  ip_address = google_compute_global_address.uid2_ip_1.address
  port_range = "443"
}

resource "google_compute_global_forwarding_rule" "uid2_http_1" {
  name       = "uid2-http-rule-1"
  target     = google_compute_target_http_proxy.uid2_http_proxy.self_link
  ip_address = google_compute_global_address.uid2_ip_1.address
  port_range = "80"
}

resource "google_compute_global_forwarding_rule" "uid2_https_2" {
  name       = "uid2-https-rule-2"
  target     = google_compute_target_https_proxy.uid2_https_proxy.self_link
  ip_address = google_compute_global_address.uid2_ip_2.address
  port_range = "443"
}

resource "google_compute_global_forwarding_rule" "uid2_http_2" {
  name       = "uid2-http-rule-2"
  target     = google_compute_target_http_proxy.uid2_http_proxy.self_link
  ip_address = google_compute_global_address.uid2_ip_2.address
  port_range = "80"
}

# Proxies
resource "google_compute_target_https_proxy" "uid2_https_proxy" {
  name        = "uid2-https-proxy"
  description = "HTTPS proxy for uid2"
  url_map     = google_compute_url_map.uid2_v1.self_link

  ssl_certificates = [
    google_compute_managed_ssl_certificate.uid2-v1.self_link,
  ]
}

resource "google_compute_target_http_proxy" "uid2_http_proxy" {
  name        = "uid2-http-proxy"
  description = "HTTP proxy for uid2"
  url_map     = google_compute_url_map.uid2_v1.self_link
}

resource "google_compute_health_check" "http_status" {
  name                = "http-status"
  timeout_sec         = 2
  unhealthy_threshold = 2
  http_health_check {
    port_specification = "USE_SERVING_PORT"
    proxy_header       = "NONE"
    request_path       = "/status"
  }
}

resource "google_compute_health_check" "http_root" {
  name                = "http-root"
  timeout_sec         = 2
  unhealthy_threshold = 2
  http_health_check {
    port_specification = "USE_SERVING_PORT"
    proxy_header       = "NONE"
    request_path       = "/"
  }
}

resource "google_compute_firewall" "glb-health-checks" {
  name        = "glb-health-checks"
  description = "Health Checks from GLB to uid2-server"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = local.health_check_k8s_destination_ports
  }

  # The rule applies to traffic from source_ranges OR tagged with source_tags
  source_ranges = data.google_netblock_ip_ranges.lb_hc.cidr_blocks_ipv4
  # Does not seem to work, but is suggested in the doc linked above
  source_tags = ["lb"]
}

resource "google_compute_backend_service" "uid2_server" {
  name        = "uid2-server"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  lifecycle {
    ignore_changes = [ backend ]
  }

  health_checks = [google_compute_health_check.http_status.self_link]
}

resource "google_compute_url_map" "uid2_v1" {
  name            = "uid2-v1"
  description     = "uid2 services"
  default_service = google_compute_backend_service.uid2_server.self_link
  host_rule {
    hosts        = ["*"]
    path_matcher = "uid2"
  }

  path_matcher {
    name            = "uid2"
    default_service = google_compute_backend_service.uid2_server.self_link

#    path_rule {
#      paths   = ["/custom"]
#      service = google_compute_backend_service.custom.self_link
#    }
  }
}
