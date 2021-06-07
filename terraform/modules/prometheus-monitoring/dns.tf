resource "google_compute_global_address" "grafana" {
  name = var.is_global ? "grafana" : "grafana-${var.cluster}"
}
resource "google_dns_record_set" "grafana" {
  name = "grafana-${var.cluster}.${data.google_dns_managed_zone.uid2-0.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.uid2-0.name
  rrdatas      = [google_compute_global_address.grafana.address]
}

resource "google_dns_record_set" "grafana-global" {
  count = var.is_global ? 1 : 0
  name  = "grafana.${data.google_dns_managed_zone.uid2-0.dns_name}"
  type  = "A"
  ttl   = 300

  managed_zone = data.google_dns_managed_zone.uid2-0.name
  rrdatas      = [google_compute_global_address.grafana.address]
}

resource "google_compute_global_address" "thanos" {
  name = var.is_global ? "thanos" : "thanos-${var.cluster}"
}
resource "google_dns_record_set" "thanos" {
  name = "thanos-${var.cluster}.${data.google_dns_managed_zone.uid2-0.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.uid2-0.name
  rrdatas      = [google_compute_global_address.thanos.address]
}

resource "google_dns_record_set" "alertmanager" {
  name = "alertmanager-${var.cluster}.${data.google_dns_managed_zone.uid2-0.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.uid2-0.name
  rrdatas      = [google_compute_global_address.thanos.address]
}
