locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Application = "Retail Commerce Platform"
    Repository  = "retail-commerce-platform"
  }
}
