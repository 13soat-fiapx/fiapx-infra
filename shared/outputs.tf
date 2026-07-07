output "environment" {
  value = local.environment_name
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "cors_allowed_origins" {
  value = var.cors_allowed_origins
}
