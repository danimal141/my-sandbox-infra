module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.0"

  key_usage = "ENCRYPT_DECRYPT"
  # tmp change
  # aliases               = ["${var.system_name}"]
  aliases               = ["eks-rails2"]
  enable_default_policy = true
}
