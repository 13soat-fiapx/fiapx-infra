terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    helm = {
      source = "hashicorp/helm"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint

  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)

  token = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes = {
    host = data.aws_eks_cluster.cluster.endpoint

    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)

    token = data.aws_eks_cluster_auth.cluster.token
  }
}
