data "google_iam_policy" "statebucketadmin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:terraform@${data.google_client_config.provider.project}.iam.gserviceaccount.com",
      # Need distribution group on GSuite
      "user:ivan.gusev@openx.com",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "statebucket" {
  bucket = "uid2-infrastructure-state-prototype"
  policy_data = data.google_iam_policy.statebucketadmin.policy_data
}
