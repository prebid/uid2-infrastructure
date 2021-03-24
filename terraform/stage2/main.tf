module "eks" {
  source              = "../modules/eks"
  project             = local.project_id
}