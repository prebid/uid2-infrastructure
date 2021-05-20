%{ for region in regions ~}
module "gke_${region}" {
  source = "../modules/k8s-gke"
  environment = "${environment}"
  region = "${region}"
  compute_service_account = "${compute_service_account}"
  iap_brand = "${iap_brand}"
}
%{ endfor ~}
