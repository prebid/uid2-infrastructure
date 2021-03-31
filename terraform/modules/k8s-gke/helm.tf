resource "helm_release" "autoneg" {
  name       = "autoneg"
  chart      = "${path.module}/helm/autoneg"
  namespace  = "autoneg-system"
  create_namespace = true
  values = [ "workloadIdentity: autoneg-system@${local.project_id}.iam.gserviceaccount.com" ]
}

resource "helm_release" "zone-printer" {
  name       = "zone-printer"
  chart      = "${path.module}/helm/zone-printer"
  namespace  = "zone-printer"
  create_namespace = true
  depends_on = [ helm_release.autoneg ]
}
