variable "project_id" {
  default = "uid2-dev"
}

variable "domain_managed_zone" {
  default = "uid2-0"
}

variable "location" {
  default = "us-east1"
}

variable "cluster" {
  default = "mission-control"
}

variable "is_global" {
  description = "Is this instance global? True for mission control cluster"
  default     = false
}

variable "thanos_query_backends" {
  description = "List of thanos query backends"
  default     = []
}

variable "iap_brand" {
  description = "google_iap_brand.name"
}

variable "environment" {
  default = "dev"
}

variable "mission_control_ips" {
  default = []
}
