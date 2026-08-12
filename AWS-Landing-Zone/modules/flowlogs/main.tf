resource "aws_cloudwatch_log_group" "flowlogs" {

  name = "/aws/vpc/${var.environment}-flowlogs"

  retention_in_days = 30

}

resource "aws_iam_role" "flowlogs" {

  name = "${var.environment}-flowlogs-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "vpc-flow-logs.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}

resource "aws_iam_role_policy" "flowlogs" {

  name = "${var.environment}-flowlogs-policy"

  role = aws_iam_role.flowlogs.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"

        ]

        Resource = "*"

      }

    ]

  })

}

resource "aws_flow_log" "this" {

  iam_role_arn = aws_iam_role.flowlogs.arn

  log_destination = aws_cloudwatch_log_group.flowlogs.arn

  traffic_type = "ALL"

  vpc_id = var.vpc_id

}