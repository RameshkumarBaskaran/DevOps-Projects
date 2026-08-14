resource "aws_s3_bucket" "config" {

  bucket = "${var.environment}-config-bucket"

  tags = {
    Name        = "${var.environment}-config"
    Environment = var.environment
  }

}

resource "aws_s3_bucket_versioning" "config" {

  bucket = aws_s3_bucket.config.id

  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_iam_role" "config" {

  name = "${var.environment}-config-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "config.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "config" {

  role = aws_iam_role.config.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"

}

resource "aws_config_configuration_recorder" "this" {

  name = "${var.environment}-config-recorder"

  role_arn = aws_iam_role.config.arn

  recording_group {

    all_supported = true

    include_global_resource_types = true

  }

}

resource "aws_config_delivery_channel" "this" {

  name = "${var.environment}-delivery-channel"

  s3_bucket_name = aws_s3_bucket.config.bucket

}