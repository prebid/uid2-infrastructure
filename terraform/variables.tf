variable "environment" {
  type        = string
  description = "dev|prod"
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
