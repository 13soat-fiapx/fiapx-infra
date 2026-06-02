resource "aws_eks_cluster" "cluster" {
  name     = "${local.prefix}-cluster"
  role_arn = data.aws_iam_role.lab_cluster_role.arn

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"

    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids = data.terraform_remote_state.shared.outputs.private_subnet_ids

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  upgrade_policy {
    support_type = "STANDARD"
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "general-purpose"
  node_role_arn   = data.aws_iam_role.lab_node_role.arn
  subnet_ids      = data.terraform_remote_state.shared.outputs.private_subnet_ids

  scaling_config {
    desired_size = 2

    max_size = 3
    min_size = 1
  }

  instance_types = ["t3.medium", "t3a.medium", "t2.medium"]
  capacity_type  = "SPOT"
}

# data for helm provider

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.cluster.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.cluster.name
}
