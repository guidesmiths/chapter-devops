resource "aws_api_gateway_resource" "animals" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.api_gateway_root_resource_id
  path_part   = "animals"
}

resource "aws_api_gateway_resource" "animals_xxx" {
  rest_api_id = var.api_gateway_id
  parent_id   = aws_api_gateway_resource.animals.id
  path_part   = "{param}"
}

resource "aws_api_gateway_method" "get_animals_xxx" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.animals_xxx.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_animals" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.animals.id
  http_method   = "POST"
  authorization = "NONE"
}

module "get_animal" {
  source                  = "./get_animal"
  environment             = var.environment
  api_gateway_id          = var.api_gateway_id
  api_gateway_resource_id = aws_api_gateway_resource.animals_xxx.id
  http_method             = aws_api_gateway_method.get_animals_xxx.http_method
  dynamodb_table_name     = var.dynamodb_table_animals_name
  dynamodb_table_arn      = var.dynamodb_table_animals_arn
  iam_arn                 = aws_iam_role.api_gateway_dynamodb_table_animals.arn
}

module "save_animal" {
  source                  = "./save_animal"
  environment             = var.environment
  api_gateway_id          = var.api_gateway_id
  api_gateway_resource_id = aws_api_gateway_resource.animals.id
  http_method             = aws_api_gateway_method.post_animals.http_method
  dynamodb_table_name     = var.dynamodb_table_animals_name
  dynamodb_table_arn      = var.dynamodb_table_animals_arn
  iam_arn                 = aws_iam_role.api_gateway_dynamodb_table_animals.arn

}
