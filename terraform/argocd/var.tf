variable "region" {
  type        = string
  description = "AWS region where secrets are stored."
  default     = "ap-south-1"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "sample-flask-eks"
}

variable "helm_chart_name" {
  type        = string
  default     = "argocd"
  description = "Helm chart name to be installed"
}

variable "helm_chart_release_name" {
  type        = string
  default     = "argo-cd"
  description = "Helm release name"
}

variable "helm_chart_version" {
  type        = string
  default     = "9.4.2"
  description = "Helm chart version."
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
  description = "helm chart repository name."
}

variable "namespace" {
  type        = string
  default     = "argocd"
  description = "Kubernetes namespace to deploy helm chart."
}