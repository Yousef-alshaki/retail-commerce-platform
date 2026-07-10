resource "aws_vpc" "retail" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc"
    }
  )
}
resource "aws_subnet" "this" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.retail.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.tier == "public"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-${each.key}-subnet"
      Tier = each.value.tier
    }
  )
}