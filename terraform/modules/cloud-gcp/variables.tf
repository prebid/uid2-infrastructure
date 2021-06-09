variable "environment" {
  type        = string
  description = "dev|qa|prod"
}

variable "regions" {
  type        = list(any)
  description = "List of GCP regions"
}


# Before terraform runs Cloud Domain and Cloud DNS managed zone need to be created and verified
# using hack/onetime.sh script
# The name of managed DNS zone created by onetime.sh script is uid2-0
variable "domain_managed_zone" {
  default = "uid2-0"
}

variable "iap_support_email" {
  description = "Support email address used to establish IAP brand"
}
