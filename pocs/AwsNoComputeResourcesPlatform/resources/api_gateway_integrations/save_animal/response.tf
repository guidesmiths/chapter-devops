resource "aws_api_gateway_method_response" "save_animal_created" {
  rest_api_id = var.api_gateway_id
  resource_id = var.api_gateway_resource_id
  http_method = var.http_method
  status_code = "201"
}

resource "aws_api_gateway_integration_response" "save_animal_mock" {
  depends_on  = [aws_api_gateway_integration.save_animal]
  rest_api_id = var.api_gateway_id
  resource_id = var.api_gateway_resource_id
  http_method = var.http_method
  status_code = aws_api_gateway_method_response.save_animal_created.status_code

  response_templates = {
    "application/json" = jsonencode({
      body = "Animal saved!"
    })
  }
}
