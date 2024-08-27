module "eks" {
  # Module specification
  source  = "terraform-aws-modules/eks/aws"
  version = "20.23.0"

  # Basic information
  cluster_name     = var.eks_cluster_name
  cluster_version  = "1.29"
  prefix_separator = ""

  # Network settings
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true
  # To support VPC internal connections from worker nodes to EKS master nodes
  # https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html
  cluster_endpoint_private_access = true

  # Security group
  cluster_security_group_description     = "EKS cluster security group."
  cluster_security_group_use_name_prefix = true
  cluster_security_group_name            = "eks-rails-20240817"
  create_node_security_group             = false

  create_kms_key            = false
  cluster_encryption_config = []

  enable_cluster_creator_admin_permissions = true

  # IAM
  enable_irsa              = true
  iam_role_use_name_prefix = true
  iam_role_name            = "eks-rails-20240817"

  # Worker node configuration
  eks_managed_node_groups = {
    main20240818 = {
      iam_role_additional_policies = {
        ssm_managed_instance_core = data.aws_iam_policy.ssm_managed_instance_core.arn
      }

      use_custom_launch_template = true

      metadata_options = {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 3
        http_tokens                 = "optional"
      }

      block_device_mappings = {
        root = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = "100"
            volume_type = "gp3"
          }
        }
      }

      # desired_size = 0
      desired_size = 2
      max_size     = 2
      min_size     = 2
      disk_size    = 50

      instance_types = [
        "t3.medium",
      ]
    }
  }

  # Log output settings
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]
}

module "eks_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.23.0"

  # Reference: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/3108
  # terraform apply with `enable_cluster_creator_admin_permissions = true` in module eks
  manage_aws_auth_configmap = true
  create_aws_auth_configmap = false

  aws_auth_roles = concat([
    {
      rolearn  = module.iam_github_oidc_role.arn
      username = module.iam_github_oidc_role.name
      groups   = ["system:masters"]
    }],
    var.map_roles
  )

  aws_auth_accounts = [
    var.aws_account_id,
  ]
}

# The following settings are necessary for the eks module to connect to the EKS cluster it created
# Cause of breaking changes between eks module v7 and v8
# https://github.com/terraform-aws-modules/terraform-aws-eks/blob/de00694a/examples/managed_node_groups/main.tf#L26-L40
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

# For Sessions Manager
data "aws_iam_policy" "ssm_managed_instance_core" {
  name = "AmazonSSMManagedInstanceCore"
}
