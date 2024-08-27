output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "https://github.com/terraform-aws-modules/terraform-aws-vpc#outputs"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "https://github.com/terraform-aws-modules/terraform-aws-vpc#outputs"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "https://github.com/terraform-aws-modules/terraform-aws-vpc#outputs"
}
