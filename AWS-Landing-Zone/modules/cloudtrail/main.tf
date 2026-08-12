resource "aws_s3_bucket" "cloudtrail_logs" {

  bucket = "${var.environment}-cloudtrail-logs"

  tags = {
    Name        = "${var.environment}-cloudtrail-logs"
    Environment = var.environment
  }

}

resource "aws_s3_bucket_versioning" "cloudtrail_logs" {

  bucket = aws_s3_bucket.cloudtrail_logs.id

  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_cloudtrail" "this" {

  name = "${var.environment}-cloudtrail"

  s3_bucket_name = aws_s3_bucket.cloudtrail_logs.id

  include_global_service_events = true

  is_multi_region_trail = true

  enable_logging = true

  depends_on = [
    aws_s3_bucket.cloudtrail_logs
  ]

}