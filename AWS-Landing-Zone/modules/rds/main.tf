resource "aws_db_instance" "mysql" {

  identifier = "${var.environment}-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  storage_type = "gp3"

  db_name  = "appdb"
  username = var.db_username
  password = var.db_password

  skip_final_snapshot = true

  publicly_accessible = false

  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = {
    Name        = "${var.environment}-mysql"
    Environment = var.environment
  }

}