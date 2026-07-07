resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${local.prefix}-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins  = data.terraform_remote_state.shared.outputs.cors_allowed_origins
    allow_methods  = ["GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"]
    allow_headers  = ["Authorization", "Content-Type"]
    expose_headers = ["ETag"]
    max_age        = 3000
  }
}

resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/aws/apigateway/${local.prefix}-api"
  retention_in_days = 7
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      caller         = "$context.identity.caller"
      user           = "$context.identity.user"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.path"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"

      authorizerError     = "$context.authorizer.error"
      authorizerStatus    = "$context.authorizer.status"
      authorizerRequestId = "$context.authorizer.requestId"
      authorizerLatency   = "$context.authorizer.latency"
    })
  }
}
