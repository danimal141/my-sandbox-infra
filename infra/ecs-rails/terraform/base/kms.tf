module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.0"

  key_usage             = "ENCRYPT_DECRYPT"
  aliases               = ["${var.system_name}"]
  enable_default_policy = true
}
