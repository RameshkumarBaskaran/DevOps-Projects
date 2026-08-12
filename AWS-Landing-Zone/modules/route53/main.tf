resource "aws_route53_zone" "this" {

  name = var.domain_name

  tags = {
    Name        = var.domain_name
    Environment = var.environment
  }
}
resource "aws_route53_record" "alb" {

  zone_id = aws_route53_zone.this.zone_id

  name = var.domain_name

  type = "A"

  alias {

    name = var.alb_dns_name

    zone_id = var.alb_zone_id

    evaluate_target_health = true

  }

}