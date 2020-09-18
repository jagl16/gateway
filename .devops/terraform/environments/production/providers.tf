terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket         = "scaling-cloud-tfstate-erik.vandam"
    key            = "scaling-cloud.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "scaling-cloud-tfstate-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 1.2.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13.1"
    }
  }
}



provider "aws" {
  region = "eu-west-1"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
  token                  = module.eks.auth_cluster_token
  load_config_file       = false
  version                = "~> 1.11"
}

provider "helm" {
  version = "~> 1.2.4"

  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
    token                  = module.eks.auth_cluster_token
    load_config_file       = false
  }
}
