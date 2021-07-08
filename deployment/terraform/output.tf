output "s3_bucket" {
	value = aws_s3_bucket.resized_images.bucket_domain_name
}

output "base_url" {
  value = aws_api_gateway_deployment.environment.invoke_url
}
