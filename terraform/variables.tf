variable "environment" {
  type        = string
  description = "dev|qa|prod"
}

variable "cloud" {
  type = string
  description = "Which cloud to deploy to"
  default = "google"
}

variable "regions" {
  type        = list
  description = "List of GCP regions"
}


# Before terraform runs Cloud Domain and Cloud DNS managed zone need to be created and verified
# using hack/onetime.sh script
# The name of managed DNS zone created by onetime.sh script is uid2-0
variable "domain_managed_zone" {
  default = "uid2-0"
}
