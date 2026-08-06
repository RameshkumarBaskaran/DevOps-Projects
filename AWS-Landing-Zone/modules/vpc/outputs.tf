output "vpc_id" {
  value = aws_vpc.this.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}
output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}
output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}

output "elastic_ip" {
  value = aws_eip.nat.public_ip
}
output "bastion_security_group_id" {
  value = aws_security_group.bastion.id
}
output "app_security_group_id" {
  value = aws_security_group.app.id
}
output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}
