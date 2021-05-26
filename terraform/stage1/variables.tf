variable "environment" {
  type        = string
  description = "dev|prod"
}

variable "regions" {
  type        = list
  description = "List of regions, can be AWS and GCP regions, Azure in the future"
}