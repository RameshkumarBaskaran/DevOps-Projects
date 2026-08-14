resource "aws_secretsmanager_secret" "db" {

  name = "${var.environment}-database-secret"

  description = "Database credentials"

  tags = {
    Name        = "${var.environment}-database-secret"
    Environment = var.environment
  }

}

resource "aws_secretsmanager_secret_version" "db" {

  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })

}