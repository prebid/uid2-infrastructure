resource "local_file" "kubeconfig" {
  sensitive_content = templatefile("${path.module}/templates/kubeconfig.yaml.tmpl", { token = data.aws_eks_cluster_auth.cluster.token, endpoint = data.aws_eks_cluster.cluster.endpoint, cluster_ca_certificate = data.aws_eks_cluster.cluster.certificate_authority.0.data, name =  })
  filename          = "${path.root}/../outputs/gcp-kubecontext-${each.key}.yaml"
  file_permission   = "0600"
}