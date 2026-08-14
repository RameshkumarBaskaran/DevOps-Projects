output "config_bucket" {

  value = aws_s3_bucket.config.bucket

}

output "configuration_recorder" {

  value = aws_config_configuration_recorder.this.name

}