%{ for index, region in regions ~}
module "gke_${region}" {
  source = "../modules/k8s-gke"
  environment = "${environment}"
  region = "${region}"
  cluster_name = "${pets[index]}"
  compute_service_account = "${compute_service_account}"
  iap_brand = "${iap_brand}"
  mission_control_ips = [ %{ for ip in mission_control_ips ~}"${ip}", %{ endfor ~} ]
}
%{ endfor ~}
