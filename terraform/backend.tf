terraform {
  backend "gcs" {
    bucket  = "uid2-infrastructure-state-prototype"
    prefix  = "terraform/state"
  }
}
