# Create EKS cluster
resource "aws_eks_cluster" "my_eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    # subnet_ids = aws_subnet.private_subnet.*.id
    # subnet_ids = "aws_subnet.money-pal-priv-1.id"
    subnet_ids = ["${aws_subnet.priv-1.id}", "${aws_subnet.priv-2.id}"]
  }
}

# Create IAM role for EKS cluster
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach policies to IAM role for EKS cluster
resource "aws_iam_role_policy_attachment" "eks_cluster_policies" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policies" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_cluster.name
}
