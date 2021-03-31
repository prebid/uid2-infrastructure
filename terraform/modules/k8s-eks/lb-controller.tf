resource "helm_release" "aws-lb-crd" {
  name       = "aws-load-balancer-controller-crd"
  repository = "https://aws.github.io/eks-charts"
  chart      = "${path.module}/helm/aws-lb-crd"
  namespace  = "kube-system"
}

resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  values =  [ "clusterName: ${local.cluster_name}",
              "serviceAccount.create: true",
              "serviceAccount.name: aws-load-balancer-controller",
            ]
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.loadbalancer_controller.arn
    type = "string"
  }
  depends_on = [ helm_release.aws-lb-crd ]
}


# Sample app
resource "helm_release" "zone-printer" {
  name       = "zone-printer"
  chart      = "${path.module}/helm/zone-printer"
  namespace  = "zone-printer"
  create_namespace = true
  depends_on = [ helm_release.aws-load-balancer-controller ]
  set {
    name = "targetGroupARN"
    value = aws_alb_target_group.uid2.arn
  }
  set {
    name = "nodePort"
    value = var.node_port
  }
}
