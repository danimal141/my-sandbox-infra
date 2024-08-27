module "iam_assumable_role_vpc_cni" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.41.0"
  create_role                   = true
  role_name                     = "eks-addon-vpc-cni"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-node"]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = var.eks_cluster_name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.18.3-eksbuild.1"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = module.iam_assumable_role_vpc_cni.iam_role_arn
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = var.eks_cluster_name
  addon_name                  = "coredns"
  addon_version               = "v1.11.1-eksbuild.11"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = var.eks_cluster_name
  addon_name                  = "kube-proxy"
  addon_version               = "v1.29.3-eksbuild.5"
  resolve_conflicts_on_update = "OVERWRITE"
}

# resource "aws_eks_addon" "aws_ebs_csi_driver" {
#   cluster_name             = var.eks_cluster_name
#   addon_name               = "aws-ebs-csi-driver"
#   addon_version            = "v1.15.0-eksbuild.1"
#   resolve_conflicts_on_update = "OVERWRITE"
#   service_account_role_arn = module.iam_assumable_role_ebs_csi_driver.iam_role_arn
# }
