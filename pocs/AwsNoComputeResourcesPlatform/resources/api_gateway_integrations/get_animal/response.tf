resource "aws_api_gateway_method_response" "get_animal_ok" {
  rest_api_id         = var.api_gateway_id
  resource_id         = var.api_gateway_resource_id
  http_method         = var.http_method
  status_code         = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "get_animal" {
  depends_on  = [aws_api_gateway_integration.get_animal]
  rest_api_id = var.api_gateway_id
  resource_id = var.api_gateway_resource_id
  http_method = var.http_method
  status_code = aws_api_gateway_method_response.get_animal_ok.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  response_templates = {
    "application/json" = <<EOF
      #set($inputRoot = $input.path('$'))
        #foreach($elem in $inputRoot.Items)
        {
          "id": "$elem.id.S",
          "name": "$elem.name.S",
        }
        #end
    EOF
  }
}
