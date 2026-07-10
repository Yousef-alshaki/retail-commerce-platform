locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Application = "Retail Commerce Platform"
    Repository  = "retail-commerce-platform"
  }

  subnets = {
    public_a = {
      cidr = cidrsubnet(var.vpc_cidr, 8, 0)
      az   = var.availability_zones[0]
      tier = "public"
    }

    public_b = {
      cidr = cidrsubnet(var.vpc_cidr, 8, 1)
      az   = var.availability_zones[1]
      tier = "public"
    }

    app_a = {
      cidr = cidrsubnet(var.vpc_cidr, 8, 10)
      az   = var.availability_zones[0]
      tier = "application"
    }

    app_b = {
      cidr = cidrsubnet(var.vpc_cidr, 8, 11)
      az   = var.availability_zones[1]
      tier = "application"
    }

    db_a = {
      cidr = cidrsubnet(var.vpc_cidr, 8, 20)
      az   = var.availability_zones[0]
      tier = "database"
    }

    db_b = {
      cidr = cidrsubnet(var.vpc_cidr, 8, 21)
      az   = var.availability_zones[1]
      tier = "database"
    }
  }
}