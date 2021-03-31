variable "region" {
  default = "us-west-1"
}

variable "environment" {
  default = "dev"
}
variable "instance_type" {
  default = "t2.medium"
}

variable "node_port" {
  description = "TargetGroup and NodePort of uid2 service"
  default = 30605
}