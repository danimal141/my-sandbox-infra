data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8.0"

  name               = var.system_name
  azs                = data.aws_availability_zones.available.names
  cidr               = "${var.cidr_prefix_16bit}.0.0/16"
  public_subnets     = ["${var.cidr_prefix_16bit}.1.0/24", "${var.cidr_prefix_16bit}.2.0/24"]
  private_subnets    = ["${var.cidr_prefix_16bit}.3.0/24", "${var.cidr_prefix_16bit}.4.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true

  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}
