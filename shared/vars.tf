variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "fiapx"
}

variable "environment" {
  type        = string
  description = "Name for the environment (dev, stg or prod)"

  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "Environment must be one of 'dev', 'stg', or 'prod'."
  }
}

variable "environment_map" {
  type = map(string)
  default = {
    dev  = "Development"
    stg  = "Staging"
    prod = "Production"
  }
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "Availability Zones to be used in the VPC"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cors_allowed_origins" {
  type = list(string)
  default = [
    "http://localhost:8080",
    "https://d2nyagk7gn75jo.cloudfront.net"
  ]
}

locals {
  prefix           = "${var.project_name}-${var.environment}"
  environment_name = var.environment_map[var.environment]
}
