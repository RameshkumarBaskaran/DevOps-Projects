resource "aws_s3_bucket" "terraform_state" {

  bucket = "${var.environment}-terraform-state-bucket"

  tags = {
    Name        = "${var.environment}-terraform-state"
    Environment = var.environment
  }

}

resource "aws_s3_bucket_versioning" "terraform_state" {

  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {

    status = "Enabled"

  }

}
resource "aws_dynamodb_table" "terraform_lock" {

  name = "${var.environment}-terraform-lock"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {

    name = "LockID"

    type = "S"

  }

  tags = {

    Name = "${var.environment}-terraform-lock"

    Environment = var.environment

  }

}