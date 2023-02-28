locals {
  resource_id = "${var.environment}-${var.name}"

  tags = merge(var.tags, {
    AppName       = var.name
    AppResourceId = local.resource_id
    Environment   = var.environment
  })
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
