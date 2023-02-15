# The policy document to access the role
data "aws_iam_policy_document" "dynamodb_table_animals_policy" {
  statement {
    sid     = "animalsdynamodbtablepolicy"
    actions = [
      "dynamodb:Query",
      "dynamodb:PutItem",
    ]
    resources = [
      var.dynamodb_table_animals_arn
    ]
  }
}

# The IAM Role for the execution
resource "aws_iam_role" "api_gateway_dynamodb_table_animals" {
  name               = "api_gateway_dynamodb_table_animals"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "apigateway.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": "iamroletrustpolicy"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "example_policy" {
  name   = "dynamodb_animals_table"
  role   = aws_iam_role.api_gateway_dynamodb_table_animals.id
  policy = data.aws_iam_policy_document.dynamodb_table_animals_policy.json
}
