resource "aws_api_gateway_rest_api" "image_resizer" {
  name        = "${var.api_gateway_name_prefix}-${terraform.workspace}"
  description = "Terraform Serverless Image Resizer Application"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.image_resizer.id
   parent_id   = aws_api_gateway_rest_api.image_resizer.root_resource_id
   path_part   = var.proxy_gateway_path
}

resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.image_resizer.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "image_resizer_lambda" {
   rest_api_id = aws_api_gateway_rest_api.image_resizer.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.image-resizer.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.image_resizer.id
   resource_id   = aws_api_gateway_rest_api.image_resizer.root_resource_id
   http_method   = "ANY"
   authorization = "CUSTOM"
}

resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.image_resizer.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.image-resizer.invoke_arn
}
resource "aws_api_gateway_deployment" "environment" {
   depends_on = [
     aws_api_gateway_integration.image_resizer_lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.image_resizer.id
   stage_name  = var.environment_name
}
resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.image-resizer.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.image_resizer.execution_arn}/*/*"
}
