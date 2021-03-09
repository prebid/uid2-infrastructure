module "workload_identity_autoneg-system" {
  source              = "./modules/workload-identity"
  name                = "autoneg-system"
  namespace           = "autoneg-system"
  project             = local.project_id
  use_existing_k8s_sa = true # Do not create kubernetes SA, fleet will deploy yaml
}
