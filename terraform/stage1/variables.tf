variable "environment" {
  type        = string
  description = "dev|prod"
}

variable "regions" {
  type        = list
  description = "List of regions, can be AWS and GCP regions, Azure in the future"
}

variable "iap_support_email" {
  description = "Support email address used to establish IAP brand"
  default = "igusev@prebid.org"
}
