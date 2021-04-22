module "gcp" {
  source = "../modules/cloud-gcp"
  environment = var.environment
  regions = local.gcp_regions
}

module "aws" {
  source = "../modules/cloud-aws"
  environment = var.environment
  regions = local.aws_regions
  mission_control_project_id = module.gcp.mission_control_project_id
}
