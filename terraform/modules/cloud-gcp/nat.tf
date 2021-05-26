resource "google_compute_router" "mission_control" {
  name    = "mission-control"
  region  = var.regions[0]
  network = data.google_compute_network.default.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_address" "mission_control" {
  count  = 2
  name   = "nat-mission-control-ip-${count.index}"
  region = google_compute_router.mission_control.region
}

resource "google_compute_router_nat" "mission_control" {
  name                               = "mission-control"
  router                             = google_compute_router.mission_control.name
  region                             = google_compute_router.mission_control.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ips                            = google_compute_address.mission_control.*.self_link
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
