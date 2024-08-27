resource "random_string" "suffix" {
  length      = 8
  special     = false
  upper       = false
  min_lower   = 1
  min_numeric = 1
}
