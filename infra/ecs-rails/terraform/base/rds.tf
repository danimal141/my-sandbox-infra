locals {
  rds_engine          = "aurora-mysql"
  rds_master_username = "root"

  # The log group names for RDS auto-export were not clearly defined in the specifications,
  # and no information beyond the slowquery example could be found in the following documentation:
  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.Concepts.MySQL.html#USER_LogAccess.MySQLDB.PublishtoCloudWatchLogs
  # We inferred the log group names by actually enabling auto-export and checking the CloudWatch logs link in the RDS console.
  # The log group names are basically referenced from the following document:
  # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Integrating.CloudWatch.html#AuroraMySQL.Integrating.CloudWatch.Monitor
  # However, since log types other than slowquery were not clearly specified, we inferred them from the actual created log groups.
  cloudwatch_logs_exports = [
    "audit",
    "error",
    "general",
    "slowquery",
  ]
}

module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.7.0"

  name = var.system_name

  engine = local.rds_engine
  # Update this with the latest version by periodically checking with the following command:
  # `aws rds describe-db-engine-versions --engine aurora-mysql | jq -r '.DBEngineVersions[].EngineVersion' | sort`
  engine_version     = "8.0.mysql_aurora.3.07.0"
  ca_cert_identifier = "rds-ca-rsa2048-g1"

  vpc_id                 = module.vpc.vpc_id
  subnets                = module.vpc.public_subnets # use public subnet
  create_db_subnet_group = true

  master_username = local.rds_master_username
  master_password = random_password.rds_master.result

  # If set to true, the password will be managed by Secrets Manager,
  # rotating every 7 days, which would break all applications using the master password
  manage_master_user_password = false

  instances_use_identifier_prefix = false
  instances = {
    for i in range(var.db_instance_count) : i => {
      instance_class = var.db_instance_type
    }
  }

  create_security_group = true
  security_group_rules = {
    cidr_ingress_ex = {
      cidr_blocks = concat(
        [
          "${var.cidr_prefix_16bit}.0.0/16",
        ]
      )
    }
  }

  monitoring_interval = 60
  publicly_accessible = true
  deletion_protection = true

  # Avoid automatic actions like restarts as much as possible
  auto_minor_version_upgrade = false

  # Set to true to avoid troubles when changes are not applied until the maintenance window
  apply_immediately = true

  preferred_backup_window      = "18:00-18:30"         # JST 03:00 AM
  preferred_maintenance_window = "wed:03:00-wed:03:30" # JST 12:00 PM

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.mysql8.id

  backtrack_window        = 86400 # = 60 * 60 * 24, i.e., 1 day
  backup_retention_period = 14    # Keep backups for 2 weeks

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  skip_final_snapshot       = false
  final_snapshot_identifier = "final-snapshot-${var.system_name}-${random_string.suffix.result}"
  copy_tags_to_snapshot     = true

  # Storage encryption settings
  storage_encrypted = true
  kms_key_id        = module.kms.key_arn
}

resource "random_password" "rds_master" {
  length  = 16
  special = true
  # https://www.terraform.io/docs/providers/random/r/password.html
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "aws_cloudwatch_log_group" "rds_export" {
  for_each          = toset(local.cloudwatch_logs_exports)
  name              = "/aws/rds/cluster/${var.system_name}/${each.value}"
  retention_in_days = 30
}
