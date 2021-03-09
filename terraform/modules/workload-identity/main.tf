# Copyright 2019 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {
  k8s_sa_gcp_derived_name = "serviceAccount:${var.project}.svc.id.goog[${var.namespace}/${var.name}]"
  create_k8s_sa           = var.use_existing_k8s_sa ? 0 : 1

  # This will cause terraform to block returninig outputs until the service account is created
  output_k8s_name      = var.use_existing_k8s_sa ? var.name : kubernetes_service_account.main[0].metadata[0].name
  output_k8s_namespace = var.use_existing_k8s_sa ? var.namespace : kubernetes_service_account.main[0].metadata[0].namespace
}

resource "kubernetes_service_account" "main" {
  count = local.create_k8s_sa
  metadata {
    name      = var.name
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.main.email
    }
  }
}

resource "google_service_account" "main" {
  account_id   = substr(var.name, 0, 30)
  display_name = substr("GCP SA bound to K8S SA ${local.k8s_sa_gcp_derived_name}", 0, 100)
  project      = var.project
}

resource "google_service_account_iam_binding" "main" {
  service_account_id = google_service_account.main.name
  role               = "roles/iam.workloadIdentityUser"

  members = [local.k8s_sa_gcp_derived_name]
}


# This role binding was added as a result of the problem observed
# on delivery-prod GKE clusters where newly created WI was unable
# to obtain token.
# Support ticket https://console.cloud.google.com/support/cases/detail/20752517?project=ox-delivery-prod
# was filed but unable to give an explanation to this.
# The need for this role binding is not documented in WI how-to page (as of Sep-2019)
# https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#enable_workload_identity_on_a_new_cluster

resource "google_service_account_iam_binding" "serviceAccountTokenCreator" {
  service_account_id = google_service_account.main.name
  role               = "roles/iam.serviceAccountTokenCreator"

  members = [local.k8s_sa_gcp_derived_name]
}
