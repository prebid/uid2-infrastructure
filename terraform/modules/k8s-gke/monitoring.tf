module "monitoring" {
  source = "../prometheus-monitoring"
  project_id = local.project_id
  domain_managed_zone = var.domain_managed_zone
  location = var.region
  cluster = google_container_cluster.this.name
  is_global = false
  # thanos_query_backends = []
}
