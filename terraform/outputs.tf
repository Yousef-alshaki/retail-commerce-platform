output "vpc_id" {
  description = "ID of the retail commerce VPC."
  value       = aws_vpc.retail.id
}

output "vpc_cidr" {
  description = "CIDR block assigned to the retail commerce VPC."
  value       = aws_vpc.retail.cidr_block
}
