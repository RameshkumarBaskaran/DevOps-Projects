resource "aws_autoscaling_group" "app" {

  name = "${var.environment}-app-asg"

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  vpc_zone_identifier = [
    var.subnet_id
  ]

  target_group_arns = [
    var.target_group_arn
  ]

  launch_template {

    id      = aws_launch_template.app.id
    version = "$Latest"

  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {

    key                 = "Name"
    value               = var.name
    propagate_at_launch = true

  }

}