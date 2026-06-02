# remote states

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "shared" {
  backend = "s3"

  config = {
    bucket = "fiapx-tf-${data.aws_caller_identity.current.account_id}"
    key    = "shared-${var.environment}.tfstate"
    region = "us-east-1"
  }
}

# roles

data "aws_iam_roles" "lab_eks_cluster_roles" {
  name_regex = ".*LabEksClusterRole.*"
}

data "aws_iam_role" "lab_cluster_role" {
  name = one(data.aws_iam_roles.lab_eks_cluster_roles.names)
}

data "aws_iam_roles" "lab_eks_node_roles" {
  name_regex = ".*LabEksNodeRole.*"
}

data "aws_iam_role" "lab_node_role" {
  name = one(data.aws_iam_roles.lab_eks_node_roles.names)
}

# locals

locals {
  prefix = "${data.terraform_remote_state.shared.outputs.project_name}-${var.environment}"
  is_dev = var.environment == "dev"
}
