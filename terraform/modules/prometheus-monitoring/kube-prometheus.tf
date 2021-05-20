resource "google_project_service" "apis" {
  for_each = toset([
    "iap.googleapis.com"
  ])

  service = each.key

  project            = var.project_id
  disable_on_destroy = false
}

resource "google_iap_client" "grafana" {
  display_name = "Grafana IAP client"
  brand        = var.iap_brand
}

locals {
  backend_yaml = yamlencode({
    "thanos" : { "grpcBackends" : [for addr in var.thanos_query_backends : addr] },
  })
}

resource "helm_release" "kube-prometheus-addons" {
  name             = "kube-prometheus-addons"
  chart            = "${path.module}/helm/kube-prometheus-addons"
  namespace        = "monitoring"
  create_namespace = false
  values = [
    file("${path.module}/kube-prometheus-addons-values.yaml"),
    var.is_global ? local.backend_yaml : ""
  ]
  set {
    name  = "tlsDomain"
    value = trimsuffix(data.google_dns_managed_zone.uid2-0.dns_name, ".")
  }
  set {
    name  = "iapClientId"
    value = google_iap_client.grafana.client_id
  }
  set {
    name  = "cluster"
    value = var.cluster
  }
  set {
    name  = "isGlobal"
    value = var.is_global
  }
  set_sensitive {
    name  = "iapClientSecret"
    value = google_iap_client.grafana.secret
  }
  depends_on = [helm_release.kube-prometheus]
}

resource "helm_release" "kube-prometheus" {
  name             = "kube-prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  values = [
    file("${path.module}/kube-prometheus-values.yaml")
  ]
  set {
    name  = "grafana.ingress.hosts"
    value = "{grafana-${var.cluster}.${trimsuffix(data.google_dns_managed_zone.uid2-0.dns_name, ".")}${var.is_global ? ", grafana.${trimsuffix(data.google_dns_managed_zone.uid2-0.dns_name, ".")}" : ""}}"
  }
  set {
    name  = "prometheus.thaonsIngress.hosts"
    value = "{thanos-${var.cluster}.${trimsuffix(data.google_dns_managed_zone.uid2-0.dns_name, ".")}}"
  }
}
