resource "aws_security_group" "alb" {

  name        = "${var.environment}-alb-sg"
  description = "Security Group for ALB"
  vpc_id      = aws_vpc.this.id

  ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
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
    Name        = "${var.environment}-alb-sg"
    Environment = var.environment
  }
}
resource "aws_lb" "this" {

  name = "${var.environment}-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name        = "${var.environment}-alb"
    Environment = var.environment
  }
}
resource "aws_lb_target_group" "app" {

  name = "${var.environment}-app-tg"

  port = 80

  protocol = "HTTP"

  vpc_id = aws_vpc.this.id

  health_check {

    enabled = true

    path = "/"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 3

    unhealthy_threshold = 3

  }

  tags = {

    Name = "${var.environment}-app-tg"

    Environment = var.environment

  }

}