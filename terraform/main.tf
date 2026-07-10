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
resource "aws_route_table" "application_private" {
  vpc_id = aws_vpc.retail.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-application-private-rt"
      Tier = "application"
    }
  )
}

resource "aws_route_table" "database_private" {
  vpc_id = aws_vpc.retail.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-database-private-rt"
      Tier = "database"
    }
  )
}

resource "aws_route_table_association" "application_private" {
  for_each = toset([
    "app_a",
    "app_b"
  ])

  subnet_id      = aws_subnet.this[each.value].id
  route_table_id = aws_route_table.application_private.id
}

resource "aws_route_table_association" "database_private" {
  for_each = toset([
    "db_a",
    "db_b"
  ])

  subnet_id      = aws_subnet.this[each.value].id
  route_table_id = aws_route_table.database_private.id
}
resource "aws_security_group" "load_balancer" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Security group for the public application load balancer"
  vpc_id      = aws_vpc.retail.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_http" {
  security_group_id = aws_security_group.load_balancer.id

  description = "Allow HTTP traffic from the internet"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "load_balancer_all" {
  security_group_id = aws_security_group.load_balancer.id

  description = "Allow outbound traffic"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
resource "aws_security_group" "application" {
  name        = "${local.name_prefix}-app-sg"
  description = "Security group for the private application tier"
  vpc_id      = aws_vpc.retail.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-app-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "application_from_load_balancer" {
  security_group_id = aws_security_group.application.id

  description                  = "Allow application traffic only from the load balancer"
  referenced_security_group_id = aws_security_group.load_balancer.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "application_all" {
  security_group_id = aws_security_group.application.id

  description = "Allow outbound traffic"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
resource "aws_security_group" "database" {
  name        = "${local.name_prefix}-db-sg"
  description = "Security group for the private database tier"
  vpc_id      = aws_vpc.retail.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-db-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "database_from_application" {
  security_group_id = aws_security_group.database.id

  description                  = "Allow MySQL traffic only from the application tier"
  referenced_security_group_id = aws_security_group.application.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}