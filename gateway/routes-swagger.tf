resource "aws_apigatewayv2_integration" "swagger_integration" {
  for_each = local.is_dev ? toset(var.services_prefix) : toset([])

  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"

  integration_uri = local.is_dev ? "http://${data.terraform_remote_state.k8s.outputs.nlb_dns_name}/${each.value}/swagger/{proxy}" : data.terraform_remote_state.k8s.outputs.nlb_listener_arn

  connection_type = local.is_dev ? null : "VPC_LINK"
  connection_id   = local.is_dev ? null : aws_apigatewayv2_vpc_link.eks[0].id

  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "swagger_proxy" {
  for_each = local.is_dev ? toset(var.services_prefix) : toset([])

  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /${each.value}/swagger/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.swagger_integration[each.key].id}"
}
