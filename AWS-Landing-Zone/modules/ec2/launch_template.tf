resource "aws_launch_template" "app" {

  name_prefix = "${var.environment}-app-"

  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = var.security_group_ids

  user_data = base64encode(file("${path.module}/user_data.sh"))

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name        = var.name
      Environment = var.environment
    }

  }

}