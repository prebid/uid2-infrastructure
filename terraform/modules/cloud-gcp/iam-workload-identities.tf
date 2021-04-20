module "workload_identity_autoneg-system" {
  source    = "./modules/workload-identity"
  name      = "autoneg-system"
  namespace = "autoneg-system"
  project   = local.project_id
}
