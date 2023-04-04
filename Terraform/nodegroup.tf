resource "aws_iam_role" "NodeGroupRole" {
  name = "MoneypalEKSGroupRole"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}



resource "aws_iam_role_policy_attachment" "NodeGroupRole-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.NodeGroupRole.name
}

resource "aws_iam_role_policy_attachment" "NodeGroupRole-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.NodeGroupRole.name
}

resource "aws_iam_role_policy_attachment" "NodeGroupRole-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.NodeGroupRole.name
}



# nodegroup

resource "aws_eks_node_group" "cluster_Node" {
  cluster_name    = aws_eks_cluster.my_eks_cluster.name
  node_group_name = "moneypal_node_group"
  node_role_arn   = aws_iam_role.NodeGroupRole.arn
  subnet_ids      = ["${aws_subnet.pub-1.id}", "${aws_subnet.pub-2.id}"]


  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }


  ami_type       = "AL2_x86_64"
  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.NodeGroupRole-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.NodeGroupRole-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.NodeGroupRole-AmazonEC2ContainerRegistryReadOnly,
  ]
}
