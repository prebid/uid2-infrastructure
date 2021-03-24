module "gcp" {
  source = "../modules/gcp"
  environment = var.environment
  regions = local.gcp_regions
}

module "aws" {
  source = "../modules/aws"
  environment = var.environment
  regions = local.aws_regions
}
