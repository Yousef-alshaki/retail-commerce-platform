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
resource "aws_internet_gateway" "retail" {
  vpc_id = aws_vpc.retail.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-igw"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.retail.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-rt"
      Tier = "public"
    }
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.retail.id
}

resource "aws_route_table_association" "public" {
  for_each = toset([
    "public_a",
    "public_b"
  ])

  subnet_id      = aws_subnet.this[each.value].id
  route_table_id = aws_route_table.public.id
}