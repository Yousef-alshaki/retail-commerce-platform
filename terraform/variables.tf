variable "aws_region" {
  description = "AWS region where the retail commerce platform will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name used to identify resources belonging to this project."
  type        = string
  default     = "retail-commerce"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, test, staging, or prod."
  }
}
variable "vpc_cidr" {
  description = "IPv4 CIDR block assigned to the retail commerce VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability Zones used for high availability."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
