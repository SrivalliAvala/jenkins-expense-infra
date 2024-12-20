/* resource "aws_key_pair" "eks" {
  key_name   = "eks"
  you can paste the public key directly like this
  # public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6ONJth+DzeXbU3oGATxjVmoRjPepdl7sBuPzzQT2Nc sivak@BOOK-I6CR3LQ85Q"
  //public_key = file("~/.ssh/eks.pub")
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLGZPHVSeBXabiLXoEG7q8hAOeexhNoNRyNf5FBGOFhZXusLPiYg7jjhVvmv6RZSUw8FJjdNjT2gtCA1eCuxACPxo5/LyKg2LBF5VN9FgYl/OT64s6m6mnl59jWIXR7yu0/4IS4APnouE4H0uRKwhd+DmYfv25kY/NkjwVKRba1Ri+4rJBO+ctRmwfHmaBPiXTYW+MVGrILAXMVpq6wmq3XifaQZrNWn22zfvwYAtLJVlDcBYNkd459Ykpa36zgsMZ/X7/+1u/hOr+6UompRsaqrrmyFqwtQRwYP85zcoQVxyMP4hVk30fJJuv+spb6kyQ8rzaTkpxmgWKyzuXzJhh ushas@SrivalliAvala"
  # ~ means windows home directory
} */

module "eks" {
  source  = "terraform-aws-modules/eks/aws"


  cluster_name    = "${var.project_name}-${var.environment}"
  cluster_version = "1.31"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = data.aws_ssm_parameter.vpc_id.value
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  create_cluster_security_group = false
  cluster_security_group_id     = local.eks_control_plane_sg_id

  create_node_security_group = false
  node_security_group_id     = local.node_sg_id

  # the user which you used to create cluster will get admin access

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    # blue = {
    #   min_size      = 3
    #   max_size      = 10
    #   desired_size  = 3
    #   capacity_type = "SPOT"
    #   iam_role_additional_policies = {
    #     AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #     AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    #     ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
    #   }
    #   # EKS takes AWS Linux 2 as it's OS to the nodes
    #   key_name = aws_key_pair.eks.key_name
    # }
    green = {
      min_size      = 3
      max_size      = 10
      desired_size  = 3
      capacity_type = "SPOT"
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
        ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
      # EKS takes AWS Linux 2 as it's OS to the nodes
      key_name = bastion-key
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  tags = var.common_tags
}