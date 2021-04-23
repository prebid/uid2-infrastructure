resource "google_gke_hub_membership" "membership" {
  membership_id = var.cluster_name
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${var.cluster_id}"
    }
  }
  description = var.cluster_name
  provider    = google-beta
}

resource "helm_release" "gke-connect" {
  name             = "gke-connect"
  chart            = "${path.module}/helm/gke-connect"
  namespace        = "gke-connect"
  create_namespace = true
  values = [
    "membership: ${google_gke_hub_membership.membership.membership_id}",
    "version: ${var.gke_connect_agent_version}",
    "credentials: ${google_service_account_key.gke_hub_sa.private_key}",
  ]
  set {
    name  = "project.number"
    value = var.project_number
    type  = "string"
  }
  set {
    name  = "project.name"
    value = var.project_id
  }
}
resource "google_service_account" "gke_hub_sa" {
  account_id   = substr("hub-${var.cluster_name}", 0, min(length(var.cluster_name), 30))
  display_name = "Service Account for GKE Hub Registration"
}

resource "google_project_iam_member" "gke_hub_member" {
  role   = "roles/gkehub.connect"
  member = "serviceAccount:${google_service_account.gke_hub_sa.email}"
}

resource "google_service_account_key" "gke_hub_sa" {
  service_account_id = google_service_account.gke_hub_sa.name
}
