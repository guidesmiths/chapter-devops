resource "aws_api_gateway_integration" "save_animal" {
  rest_api_id = var.api_gateway_id
  resource_id = var.api_gateway_resource_id
  http_method = var.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:eu-west-1:dynamodb:action/PutItem"
  credentials             = var.iam_arn

  request_templates = {
    "application/json" = <<EOF
      {
        "TableName": "${var.dynamodb_table_name}",
        "Item": {
          "id": {
              "S": "$input.path('$.id')"
          },
          "name": {
              "S": "$input.path('$.name')"
          }
        }
      }
    EOF
  }
}

output "integration_id" {
  value = aws_api_gateway_integration.save_animal.id
}
