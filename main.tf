module "network" {
  source = "./modules/network"

  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_cidr_block = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  availability_zone = var.availability_zone
}

module "cluster" {
  source = "./modules/cluster"

  cluster_name = var.cluster_name
  kubernetes_version = var.kubernetes_version
  subnet_ids = [module.network.public_subnet_id, module.network.private_subnet_id]
}

module "deployment" {
  source = "./modules/deployment"

  depends_on = [module.cluster]
}

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = module.cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.cluster.cluster_certificate_authority)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.cluster.cluster_name]
  }
}