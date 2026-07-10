output "vpc_id" {
  description = "ID of the retail commerce VPC."
  value       = aws_vpc.retail.id
}

output "vpc_cidr" {
  description = "CIDR block assigned to the retail commerce VPC."
  value       = aws_vpc.retail.cidr_block
}
output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value = [
    aws_subnet.this["public_a"].id,
    aws_subnet.this["public_b"].id
  ]
}

output "application_subnet_ids" {
  description = "IDs of the private application subnets."
  value = [
    aws_subnet.this["app_a"].id,
    aws_subnet.this["app_b"].id
  ]
}

output "database_subnet_ids" {
  description = "IDs of the private database subnets."
  value = [
    aws_subnet.this["db_a"].id,
    aws_subnet.this["db_b"].id
  ]
}

output "subnet_cidr_blocks" {
  description = "CIDR blocks assigned to all platform subnets."
  value = {
    for name, subnet in aws_subnet.this :
    name => subnet.cidr_block
  }
}
output "internet_gateway_id" {
  description = "ID of the Internet Gateway attached to the VPC."
  value       = aws_internet_gateway.retail.id
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}
output "application_private_route_table_id" {
  description = "ID of the private application route table."
  value       = aws_route_table.application_private.id
}

output "database_private_route_table_id" {
  description = "ID of the private database route table."
  value       = aws_route_table.database_private.id
}

output "load_balancer_security_group_id" {
  description = "ID of the load balancer security group."
  value       = aws_security_group.load_balancer.id
}

output "application_security_group_id" {
  description = "ID of the application security group."
  value       = aws_security_group.application.id
}

output "database_security_group_id" {
  description = "ID of the database security group."
  value       = aws_security_group.database.id
}