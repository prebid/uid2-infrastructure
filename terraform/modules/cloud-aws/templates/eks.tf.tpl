%{ for region in regions ~}
module "eks_${region}" {
  source = "../modules/k8s-eks"
  environment = "${environment}"
  region = "${region}"
  providers = {
    aws = aws.${region}
  }
}
%{ endfor ~}