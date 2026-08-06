resource "aws_cloudwatch_dashboard" "this" {

  dashboard_name = "${var.environment}-dashboard"

  dashboard_body = jsonencode({

    widgets = [

      {
        type = "metric"

        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {

          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              var.instance_id
            ]
          ]

          period = 300

          stat = "Average"

          region = "ap-south-1"

          title = "EC2 CPU Utilization"

        }

      }

    ]

  })

}
resource "aws_cloudwatch_metric_alarm" "cpu_high" {

  alarm_name = "${var.environment}-high-cpu"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 300

  statistic = "Average"

  threshold = 80

  alarm_description = "Alarm when EC2 CPU exceeds 80%"

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}
resource "aws_sns_topic" "alerts" {

  name = "${var.environment}-alerts"

}

resource "aws_sns_topic_subscription" "email" {

  topic_arn = aws_sns_topic.alerts.arn

  protocol = "email"

  endpoint = var.notification_email

}