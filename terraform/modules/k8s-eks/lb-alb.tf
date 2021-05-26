resource "aws_alb" "uid2" {
  name = local.cluster_name
  subnets         = [ aws_subnet.eks[0].id, aws_subnet.eks[1].id ]
  security_groups = [aws_security_group.lb_uid2.id]
}

resource "aws_alb_target_group" "uid2" {
  name = local.cluster_name
  port        = var.node_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id        = aws_vpc.eks.id

  health_check {
    enabled     = true
    interval    = 10
    path        = "/"
    timeout     = 5
    unhealthy_threshold = 2
    healthy_threshold = 2
    matcher     = "200"
  }
}

resource "aws_alb_listener" "uid" {
  load_balancer_arn = aws_alb.uid2.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.uid2.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "uid_ssl" {
  load_balancer_arn = aws_alb.uid2.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.aws_acm_certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.uid2.id
    type             = "forward"
  }
}

# Loadbalancer security group
resource "aws_security_group" "lb_uid2" {
  name_prefix   = "uid2-lb-"
  vpc_id        = aws_vpc.eks.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow loadbalancer to talk to nodeport
resource "aws_security_group_rule" "node_port" {
  type              = "ingress"
  from_port         = var.node_port
  to_port           = var.node_port
  protocol          = "tcp"
  source_security_group_id = aws_security_group.lb_uid2.id
  security_group_id = module.eks_cluster.cluster_primary_security_group_id
}
