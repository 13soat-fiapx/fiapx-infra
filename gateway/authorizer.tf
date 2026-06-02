resource "aws_apigatewayv2_authorizer" "jwt" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "fiapx-${var.environment}-auth0"

  jwt_configuration {
    issuer   = var.auth_issuer
    audience = [var.auth_audience]
  }
}
