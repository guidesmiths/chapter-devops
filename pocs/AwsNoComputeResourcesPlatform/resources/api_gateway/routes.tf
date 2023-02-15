resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "tf-apigateway-${var.environment}"
  description = "Terraformed API Gateway"
}

output "id" {
  value = aws_api_gateway_rest_api.api_gateway.id
}

output "api_gateway_root_resource_id" {
  value = aws_api_gateway_rest_api.api_gateway.root_resource_id
}
