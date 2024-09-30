variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  default = "10.0.2.0/24"
}

variable "availability_zone" {
  default = "eu-west-2a"
}

variable "cluster_name" {
  default = "regtech-cluster"
}

variable "kubernetes_version" {
  default = "1.30"
}