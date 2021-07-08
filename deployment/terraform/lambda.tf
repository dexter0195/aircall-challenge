locals {
  sources_files = "${substr(filemd5(var.sources_zip),0,16)}.zip"
}

# Upload sources on S3
resource "aws_s3_bucket_object" "sources" {
  bucket = aws_s3_bucket.releases.id
  key = "${terraform.workspace}/${local.sources_files}"
  source = var.sources_zip
  etag = filebase64sha256("${var.sources_zip}")
}

resource "aws_lambda_function" "image-resizer" {
  function_name = "${var.lambda_prefix}-${terraform.workspace}"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "app.lambdaHandler"

  depends_on = [
    aws_s3_bucket_object.sources
  ]

  s3_bucket = aws_s3_bucket.releases.id
  s3_key    = aws_s3_bucket_object.sources.key

  runtime = var.lambda_runtime

  # Enable Tracing
  tracing_config {
	  mode = "Active"
  }

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.resized_images.id
    }
  }
}