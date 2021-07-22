module "workload_identity_autoneg-system" {
  source     = "./modules/workload-identity"
  name       = "autoneg-system"
  namespace  = "autoneg-system"
  project    = local.project_id
  depends_on = [google_iam_workload_identity_pool.project]
}
