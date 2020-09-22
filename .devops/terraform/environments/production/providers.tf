provider "aws" {
  region = "eu-west-1"
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.core.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.core.outputs.eks_cluster_certificate_authority)
  token                  = data.terraform_remote_state.core.outputs.eks_cluster_token
  load_config_file       = false
  version                = "~> 1.11"
}

provider "helm" {
  version = "~> 1.2.4"

  kubernetes {
    host                   = data.terraform_remote_state.core.outputs.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.core.outputs.eks_cluster_certificate_authority)
    token                  = data.terraform_remote_state.core.outputs.eks_cluster_token
    load_config_file       = false
  }
}
