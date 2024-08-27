resource "aws_ssm_parameter" "placeholders" {
  # https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/sysman-paramstore-hierarchies.html
  for_each = {
    github_machine_user_ssh_private_key = { name = "/github/machine-user/ssh-private-key", is_secure = true }
    rails_master_key                    = { name = "/${var.system_name}/rails/rails-master-key", is_secure = true }
  }

  name  = each.value.name
  type  = each.value.is_secure ? "SecureString" : "String"
  value = "REPLACE ME"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "rds_master_username" {
  # https://aws.amazon.com/jp/blogs/news/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/
  name   = "/${var.system_name}/rds/master-username"
  type   = "SecureString"
  key_id = "alias/aws/ssm"
  value  = local.rds_master_username
}


resource "aws_ssm_parameter" "rds_master_password" {
  # https://aws.amazon.com/jp/blogs/news/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/
  name   = "/${var.system_name}/rds/master-password"
  type   = "SecureString"
  key_id = "alias/aws/ssm"
  value  = random_password.rds_master.result
}

resource "aws_ssm_parameter" "endpoint" {
  # https://aws.amazon.com/jp/blogs/news/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/
  name   = "/${var.system_name}/rds/endpoint"
  type   = "SecureString"
  key_id = "alias/aws/ssm"
  value  = module.db.cluster_endpoint
}

resource "aws_ssm_parameter" "port" {
  # https://aws.amazon.com/jp/blogs/news/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/
  name   = "/${var.system_name}/rds/port"
  type   = "SecureString"
  key_id = "alias/aws/ssm"
  value  = module.db.cluster_port
}
