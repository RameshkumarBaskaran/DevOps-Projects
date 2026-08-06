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