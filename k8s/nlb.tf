resource "aws_lb" "eks_nlb" {
  name = local.prefix

  load_balancer_type = "network"

  subnets  = local.is_dev ? data.terraform_remote_state.shared.outputs.public_subnet_ids : data.terraform_remote_state.shared.outputs.private_subnet_ids
  internal = !local.is_dev
}

resource "aws_lb_target_group" "eks_tg" {
  name     = "${local.prefix}-tg"
  port     = var.node_port
  protocol = "TCP"
  vpc_id   = data.terraform_remote_state.shared.outputs.vpc_id

  target_type = "instance"

  health_check {
    protocol = "TCP"
  }
}

# listeners
resource "aws_lb_listener" "nlb_listener_http" {
  load_balancer_arn = aws_lb.eks_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_tg.arn
  }
}

# link ASG to target group
resource "aws_autoscaling_attachment" "asg_attachment" {
  for_each = {
    main = aws_eks_node_group.node_group.resources[0].autoscaling_groups[0].name
  }

  autoscaling_group_name = each.value
  lb_target_group_arn    = aws_lb_target_group.eks_tg.arn
}

# security group rules

resource "aws_security_group" "vpc_link" {
  name        = "${local.prefix}-vpc-link-sg"
  description = "Security group for API Gateway VPC Link"
  vpc_id      = data.terraform_remote_state.shared.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_vpc_link" {
  type              = "ingress"
  from_port         = var.node_port
  to_port           = var.node_port
  protocol          = "tcp"
  security_group_id = data.aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id

  source_security_group_id = aws_security_group.vpc_link.id
}

resource "aws_security_group_rule" "allow_nlb_healthcheck" {
  type              = "ingress"
  from_port         = var.node_port
  to_port           = var.node_port
  protocol          = "tcp"
  security_group_id = data.aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id

  cidr_blocks = [data.terraform_remote_state.shared.outputs.vpc_cidr]
}

resource "aws_security_group_rule" "allow_nlb_public" {
  count = local.is_dev ? 1 : 0

  type              = "ingress"
  from_port         = var.node_port
  to_port           = var.node_port
  protocol          = "tcp"
  security_group_id = data.aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id

  cidr_blocks = ["0.0.0.0/0"]
}
