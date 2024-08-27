resource "aws_rds_cluster_parameter_group" "mysql8" {
  name   = "${var.system_name}-mysql8"
  family = "aurora-mysql8.0"

  # Configure to use utf8mb4 everywhere
  # (utf8 can cause issues with emojis)
  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  # Disable binlog (rollback is handled by backtrack)
  parameter {
    name         = "binlog_format"
    value        = "OFF"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "time_zone"
    value        = "Asia/Tokyo"
    apply_method = "immediate"
  }

  # To send slow query logs to CloudWatch Logs
  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.Concepts.MySQL.html#USER_LogAccess.MySQLDB.PublishtoCloudWatchLogs
  # The following setting keeps appearing as a diff in the plan no matter how many times it's applied. Probably due to this issue:
  # https://github.com/hashicorp/terraform-provider-aws/issues/23335
  # Fortunately, the value is the same as when unspecified, so we've commented it out until the bug is fixed
  # parameter {
  #   name         = "log_output"
  #   value        = "FILE"
  #   apply_method = "immediate"
  # }

  # To capture slow query logs
  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.Concepts.MySQL.html#USER_LogAccess.MySQL.Generallog
  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }

  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.Concepts.MySQL.html#USER_LogAccess.MySQL.Generallog
  parameter {
    name         = "long_query_time"
    value        = "2" # = seconds (float, so decimals are OK)
    apply_method = "immediate"
  }

  # Upper limit for temporary files that can be written to local storage
  parameter {
    name  = "temptable_max_mmap"
    value = "21474836480" # = 20GiB
  }
}
