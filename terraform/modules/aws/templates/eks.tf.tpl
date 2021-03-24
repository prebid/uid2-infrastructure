%{ for region in regions ~}
module "eks_${region}" {
  source = "../modules/eks"
  environment = "${environment}"
  region = "${region}"
  providers = {
    aws = aws.${region}
  }
}
%{ endfor ~}