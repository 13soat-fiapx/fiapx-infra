output "environment" {
  value = data.terraform_remote_state.shared.outputs.environment
}

output "table_name" {
  value = aws_dynamodb_table.database.name
}
