provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      application = "eks-rails"
      environment = "production"
    }
  }
}

# For CloudFront
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
