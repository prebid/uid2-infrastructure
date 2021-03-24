variable "environment" {
  type        = string
  description = "dev|qa|prod"
}

variable "regions" {
  type        = list
  description = "List of GCP regions"
  default = []
}
