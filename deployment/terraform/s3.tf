resource "aws_s3_bucket" "resized_images" {
	# TODO: terraform multi state for multiregion
  bucket = "${var.output_bucket_prefix}-${terraform.workspace}"
  acl    = "public-read"

  tags = merge (
    var.common_tags, 
    {
      Name        = "${var.output_bucket_prefix}-${terraform.workspace}"
    }
  )
}

resource "aws_s3_bucket" "releases" {
	# TODO: terraform multi state for multiregion
  bucket = "${var.releases_bucket_prefix}-${terraform.workspace}"
  acl    = "private"

  tags = merge (
    var.common_tags,
    {}
  )
}