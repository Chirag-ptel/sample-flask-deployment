provider "aws" {
  region  = var.region
}

terraform {
  required_providers {
    argocd = {
      source = "jojand/argocd"
      version = "2.3.2"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name ]
    command     = "aws"
  }
}

terraform {
  backend "s3" {
    bucket = "my-unique-tf-state-bucket-1001"
    key    = "argocd/terraform.tfstate"
    region = "ap-south-1"
  }
}

data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint #module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data) #base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "argocd" {
  count      = var.enabled ? 1 : 0
  name       = var.helm_chart_name
  chart      = var.helm_chart_release_name
  repository = var.helm_chart_repo
  version    = var.helm_chart_version
  namespace  = var.namespace
  create_namespace = true
  upgrade_install = true

  values = [file("${path.module}/values.yaml")]
}