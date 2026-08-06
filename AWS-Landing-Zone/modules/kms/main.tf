resource "aws_kms_key" "this" {

  description = "${var.environment} KMS Key"

  deletion_window_in_days = 7

  enable_key_rotation = true

  tags = {

    Name = "${var.environment}-kms-key"

    Environment = var.environment

  }

}

resource "aws_kms_alias" "this" {

  name = "alias/${var.environment}-kms"

  target_key_id = aws_kms_key.this.key_id

}