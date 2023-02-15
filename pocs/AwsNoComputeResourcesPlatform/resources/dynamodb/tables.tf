resource "aws_dynamodb_table" "animals" {
  name           = "tf-animals-${var.environment}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  range_key      = "name"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }
}

output "table_animals_name" {
  value = aws_dynamodb_table.animals.name
}

output "table_animals_arn" {
  value = aws_dynamodb_table.animals.arn
}
