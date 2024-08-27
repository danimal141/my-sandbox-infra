provider "aws" {
  region = "ap-northeast-1"
}

# For CloudFront
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}
