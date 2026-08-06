resource "aws_security_group" "rds" {

  name        = "${var.environment}-rds-sg"
  description = "Security Group for RDS"
  vpc_id      = aws_vpc.this.id

  ingress {

    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    security_groups = [
      aws_security_group.app.id
    ]

  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  tags = {

    Name        = "${var.environment}-rds-sg"
    Environment = var.environment

  }

}