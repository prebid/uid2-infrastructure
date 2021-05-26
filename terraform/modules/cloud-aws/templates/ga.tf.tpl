resource "aws_globalaccelerator_endpoint_group" "uid2" {
  listener_arn = "${listener_arn}"
  health_check_interval_seconds = 10
  health_check_path = "/"
  health_check_protocol = "HTTP"
  threshold_count = 2

%{ for region in regions ~}
  endpoint_configuration {
    endpoint_id = module.eks_${region}.lb_arn
    weight      = 100
  }
%{ endfor ~}
}
