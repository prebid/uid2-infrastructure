module "monitoring" {
  source = "../prometheus-monitoring"
  project_id = local.project_id
  domain_managed_zone = var.domain_managed_zone
  location = var.region
  cluster = google_container_cluster.this.name
  environment = var.environment
  is_global = false
  iap_brand = var.iap_brand
  mission_control_ips = var.mission_control_ips
  # thanos_query_backends = []
}
