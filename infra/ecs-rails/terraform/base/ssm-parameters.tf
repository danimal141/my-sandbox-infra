resource "aws_ssm_parameter" "placeholder" {
  name = "/${var.system_name}/rails/rails-master-key"

  type   = "SecureString"
  key_id = "alias/aws/ssm"
  value  = "REPLACE ME"

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
