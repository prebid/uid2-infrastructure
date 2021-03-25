resource "aws_iam_policy" "policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "EKS LoadBalancer Controller policy"

  policy = file("${path.module}/policy/awslb-policy.json")
}
