variable "cluster_name" {
}

variable "region" {
  default = "us-east-1"
}

variable "environment" {
  default = "dev"
}

variable "compute_service_account" {
}

variable "domain_managed_zone" {
  default = "uid2-0"
}

variable "iap_brand" {
}

variable "mission_control_ips" {
  default = []
}