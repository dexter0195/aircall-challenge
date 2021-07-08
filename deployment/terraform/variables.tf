variable "common_tags" {
  type = map(string)
}
variable "output_bucket_prefix" {
  type = string
}
variable "releases_bucket_prefix" {
  type = string
}
variable "api_gateway_name_prefix" {
  type = string
}
variable "proxy_gateway_path" {
  type = string
}
variable "lambda_prefix" {
  type = string
}
variable "lambda_runtime" {
  type = string
}
variable "sources_zip" {
  type = string
}
variable "environment_name" {
  type = string
}