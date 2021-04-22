%{ for region in regions ~}
module "eks_${region}" {
  source = "../modules/k8s-eks"
  environment = "${environment}"
  region = "${region}"
  aws_acm_certificate_arn = "${aws_acm_certificate}"
  mission_control_project_id = "${mission_control_project_id}"
  providers = {
    aws = aws.${region}
  }
}
%{ endfor ~}
