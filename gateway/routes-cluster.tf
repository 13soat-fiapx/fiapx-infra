resource "aws_apigatewayv2_vpc_link" "eks" {
  count = local.is_dev ? 0 : 1

  name               = "${local.prefix}-vpc-link"
  security_group_ids = [data.terraform_remote_state.k8s.outputs.vpc_link_security_group_id]
  subnet_ids         = data.terraform_remote_state.shared.outputs.private_subnet_ids
}

resource "aws_apigatewayv2_integration" "eks_integration" {
  for_each = toset(var.services_prefix)

  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"

  integration_uri = local.is_dev ? "http://${data.terraform_remote_state.k8s.outputs.nlb_dns_name}/${each.value}/{proxy}" : data.terraform_remote_state.k8s.outputs.nlb_listener_arn

  connection_type = local.is_dev ? null : "VPC_LINK"
  connection_id   = local.is_dev ? null : aws_apigatewayv2_vpc_link.eks[0].id

  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "eks_proxy" {
  for_each = toset(var.services_prefix)

  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /${each.value}/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.eks_integration[each.key].id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt.id
}

resource "aws_apigatewayv2_integration" "eks_integration_public" {
  for_each = toset(var.public_routes)

  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"

  integration_uri = local.is_dev ? "http://${data.terraform_remote_state.k8s.outputs.nlb_dns_name}/${each.value}" : data.terraform_remote_state.k8s.outputs.nlb_listener_arn

  connection_type = local.is_dev ? null : "VPC_LINK"
  connection_id   = local.is_dev ? null : aws_apigatewayv2_vpc_link.eks[0].id

  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "eks_proxy_public" {
  for_each = toset(var.public_routes)

  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /${each.value}"
  target    = "integrations/${aws_apigatewayv2_integration.eks_integration_public[each.key].id}"
}
