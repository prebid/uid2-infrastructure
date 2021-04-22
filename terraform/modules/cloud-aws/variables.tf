variable "environment" {
  type        = string
  description = "dev|qa|prod"
}

variable "regions" {
  type        = list
  description = "List of GCP regions"
  default = []
}

# Before terraform runs Cloud Domain and Cloud DNS managed zone need to be created and verified
# using hack/onetime.sh script
# The name of managed DNS zone created by onetime.sh script is uid2-0
# TBD: allow to choose between aws managed zone and gcp managed zone
variable "domain_managed_zone" {
  default = "uid2-0"
}


variable "global_resources_region" {
  default = "us-west-1" # Do not change unless absolutely required
}

# Project name for Anthos
variable "mission_control_project_id" {
}
