terraform {
  backend "s3" {
    # cannnot use variables
    # https://qiita.com/ymmy02/items/e7368abd8e3dafbc5c52
    region         = "ap-northeast-1"
    bucket         = "eks-rails-production-terraform-state"
    key            = "terraform.tfstate"
    dynamodb_table = "eks-rails-production-terraform-state-lock"
    encrypt        = true
  }
}

module "terraform_state_backend" {
  source      = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=1.4.0"
  namespace   = "eks-rails"
  environment = "production"
  name        = "terraform"
  attributes  = ["state"]
}