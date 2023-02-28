module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = local.resource_id

  autoscaling_capacity_providers = {
    "main" = {
      auto_scaling_group_arn         = aws_autoscaling_group.ecs_main.arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 1
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 100
      }

      default_capacity_provider_use_fargate = false

      default_capacity_provider_strategy = {
        weight = 100
        base   = 1
      }
    }
  }

  tags = local.tags
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = "/aws/ecs/${var.environment}/${var.name}"
}
