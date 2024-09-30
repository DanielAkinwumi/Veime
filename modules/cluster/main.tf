variable "subnet_ids" {
  type = list(string)
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version = var.kubernetes_version
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access = false
    endpoint_private_access = true
  }

  # Enable encryption for secrets at rest
encryption_config {
    provider {
      key_arn = aws_kms_key.eks_secrets_encryption.arn
    }
    resources = ["secrets"]
  }
}
# Create KMS key for EKS secrets encryption
resource "aws_kms_key" "eks_secrets_encryption" {
  description = "KMS key for encrypting EKS secrets"
  enable_key_rotation = true
}

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# Create a node group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${aws_eks_cluster.main.name}-node-group" 
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 3
    max_size     = 10
    min_size     = 1
  }

  # ... other configurations ...
}

# IAM role for the node group
resource "aws_iam_role" "node_group" {
  name = "eks-node-group-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attached the AmazonEKSClusterPolicy to node group role
resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.node_group.name
}

# Attached the AmazonEKSWorkerNodePolicy to node group role
resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group.name
}

# CloudWatch Container Insights
resource "aws_eks_addon" "cloudwatch_container_insights" {
  addon_name               = "cloudwatch-container-insights"
  cluster_name             = aws_eks_cluster.main.name
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn = aws_iam_role.cloudwatch_agent.arn
}

resource "aws_iam_role" "cloudwatch_agent" {
  name = "cloudwatch-agent-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks-fargate-pods.amazonaws.com"
      },
      "Action": "sts:AssumeRole"   

    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cloudwatch_agent.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.cloudwatch_agent.name
}