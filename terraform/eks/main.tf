provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

terraform {
  backend "s3" {
    bucket = "my-unique-tf-state-bucket-1001"
    key    = "eks/terraform.tfstate"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket         = "my-unique-tf-state-bucket-1001"
    key            = "vpc/terraform.tfstate"
    region         = "ap-south-1"
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name    = "${var.cluster_name}"
  kubernetes_version = "1.34"

  vpc_id                         = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids                     = data.terraform_remote_state.vpc.outputs.private_subnets
  endpoint_public_access = true
  
  addons = {
      coredns                = {}
      eks-pod-identity-agent = {
        before_compute = true
      }
      kube-proxy             = {}
      vpc-cni                = {
        before_compute = true
      }
    }


  enable_cluster_creator_admin_permissions = true
  

  eks_managed_node_groups = {
    c6a_x86_64 = {
      name = "${var.cluster_name}"

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

data "aws_caller_identity" "current" {}

resource "aws_eks_access_entry" "eks_access_entry" {
  cluster_name  = module.eks.cluster_name
  principal_arn = data.aws_caller_identity.current.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks-access-policy-attach" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = data.aws_caller_identity.current.arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "eks-admin-policy-attach" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_caller_identity.current.arn

  access_scope {
    type = "cluster"
  }
}
