output "environment" {
  value = data.terraform_remote_state.shared.outputs.environment
}

output "container_registry_names" {
  value = [for repo in aws_ecr_repository.container_registry : repo.name]
}

output "container_registry_uris" {
  value = { for k, repo in aws_ecr_repository.container_registry : k => repo.repository_url }
}
