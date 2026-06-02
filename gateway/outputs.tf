output "environment" {
  value = data.terraform_remote_state.shared.outputs.environment
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.api_gateway.api_endpoint
}

output "public_routes" {
  value = var.public_routes
}
