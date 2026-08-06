resource "aws_iam_role" "ec2_role" {

  name = "${var.environment}-ec2-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "ec2.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

  tags = {

    Name = "${var.environment}-ec2-role"

    Environment = var.environment

  }

}

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

resource "aws_iam_instance_profile" "ec2_profile" {

  name = "${var.environment}-instance-profile"

  role = aws_iam_role.ec2_role.name

}
resource "aws_iam_policy" "ec2_custom_policy" {

  name = "${var.environment}-ec2-custom-policy"

  description = "Custom policy for EC2 instances"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "ec2:DescribeInstances",

          "ec2:DescribeTags"

        ]

        Resource = "*"

      },

      {

        Effect = "Allow"

        Action = [

          "cloudwatch:PutMetricData"

        ]

        Resource = "*"

      }

    ]

  })

}
resource "aws_iam_role_policy_attachment" "custom_policy" {

  role = aws_iam_role.ec2_role.name

  policy_arn = aws_iam_policy.ec2_custom_policy.arn

}