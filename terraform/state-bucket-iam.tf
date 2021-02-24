resource "google_service_account" "terraform" {
  account_id   = "terraform"
  display_name = "Terraform service account"
}

data "google_iam_policy" "statebucketadmin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:${google_service_account.terraform.email}",
      # Need distribution group on GSuite
      "user:ivan.gusev@openx.com",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "statebucket" {
  bucket = "uid2-infrastructure-state-prototype"
  policy_data = data.google_iam_policy.statebucketadmin.policy_data
}
