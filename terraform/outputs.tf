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