# remote states

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "k8s" {
  backend = "s3"

  config = {
    bucket = "fiapx-tf-${data.aws_caller_identity.current.account_id}"
    key    = "k8s-${var.environment}.tfstate"
    region = "us-east-1"
  }
}

# cluster authentication data

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.k8s.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.k8s.outputs.cluster_name
}

# locals

locals {
  datadog_enabled = var.datadog_api_key != "" ? 1 : 0
}
