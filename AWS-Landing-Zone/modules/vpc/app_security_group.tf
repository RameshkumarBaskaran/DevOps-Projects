resource "aws_security_group" "app" {

  name        = "${var.environment}-app-sg"
  description = "Application Security Group"
  vpc_id      = aws_vpc.this.id

  ingress {

    description = "Allow HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/16"
    ]
  }

  ingress {

    description = "Allow HTTPS"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/16"
    ]
  }

  ingress {

    description = "SSH from Bastion"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = [
      aws_security_group.bastion.id
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

    Name        = "${var.environment}-app-sg"
    Environment = var.environment
  }
}