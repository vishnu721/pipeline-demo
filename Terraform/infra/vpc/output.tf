output "id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnets
  description = "List of public subnet IDs"
}

output "default_security_group_id" {
    value = module.vpc.default_security_group_id
}