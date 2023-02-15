resource "aws_api_gateway_deployment" "auto_deployment" {
  rest_api_id = var.api_gateway_id
  triggers    = {
    redeployment = sha1(jsonencode([
      var.api_gateway_id,
      aws_api_gateway_resource.animals,
      aws_api_gateway_resource.animals_xxx,
      aws_api_gateway_method.get_animals_xxx,
      aws_api_gateway_method.post_animals,
      module.get_animal,
      module.save_animal,
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.auto_deployment.id
  rest_api_id   = var.api_gateway_id
  stage_name    = "api"
}

