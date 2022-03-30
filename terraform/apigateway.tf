resource "aws_api_gateway_rest_api" "lambda" {
  name = "serverless_lambda_gw"
}

resource "aws_api_gateway_method" "proxy-root" {
  rest_api_id   = aws_api_gateway_rest_api.lambda.id
  resource_id   = aws_api_gateway_rest_api.lambda.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.lambda.id
  resource_id             = aws_api_gateway_rest_api.lambda.root_resource_id
  http_method             = aws_api_gateway_method.proxy-root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_world.invoke_arn
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.lambda.id
  parent_id   = aws_api_gateway_rest_api.lambda.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_deployment" "lambda" {
  depends_on = [
    aws_api_gateway_integration.lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.lambda.id
  stage_name  = "v1"
}
