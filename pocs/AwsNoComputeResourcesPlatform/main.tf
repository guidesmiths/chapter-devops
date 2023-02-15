variable "environment" {
  type        = string
  description = "environment name"
  default     = "dev"
}

module "api_gateway" {
  source      = "./resources/api_gateway"
  environment = var.environment
}

module "api_gateway_integrations" {
  source                       = "./resources/api_gateway_integrations"
  environment                  = var.environment
  api_gateway_id               = module.api_gateway.id
  api_gateway_root_resource_id = module.api_gateway.api_gateway_root_resource_id
  dynamodb_table_animals_name  = module.dynamodb.table_animals_name
  dynamodb_table_animals_arn   = module.dynamodb.table_animals_arn
}

module "dynamodb" {
  source      = "./resources/dynamodb"
  environment = var.environment
}
