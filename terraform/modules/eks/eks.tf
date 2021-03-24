data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host     = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  namespace = "test"
  create_namespace = true

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}


module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.region
  cluster_version = "1.19"
  subnets         = [ aws_subnet.eks[0].id, aws_subnet.eks[1].id ]
  vpc_id          = aws_vpc.eks.id
  # cluster_endpoint_private_access = true

  node_groups = {
    "primary" = {
    public_ip = true
    instance_types = ["t3.medium"]
    }
  }
}
