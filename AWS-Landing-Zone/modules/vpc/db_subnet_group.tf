resource "aws_db_subnet_group" "this" {

  name = "${var.environment}-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }

}