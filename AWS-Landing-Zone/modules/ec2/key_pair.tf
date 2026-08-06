resource "aws_key_pair" "this" {

  key_name = "${var.environment}-ec2-key"

  public_key = var.public_key
}