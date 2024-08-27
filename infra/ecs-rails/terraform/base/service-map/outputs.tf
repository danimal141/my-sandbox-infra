# lob logs (s3)
output "log_bucket" {
  value = aws_s3_bucket.log_bucket

  depends_on = [
    # The bucket must be configured with correct bucket policy before it is used as
    # a log destination of LBs
    aws_s3_bucket_policy.log_bucket_policy
  ]
}

output "alb_prefix" {
  value = var.alb_prefix
}
