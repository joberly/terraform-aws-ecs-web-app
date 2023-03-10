resource "aws_ecs_service" "main" {
  name            = "main"
  cluster         = module.cluster.cluster_id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 2
  iam_role        = aws_iam_role.app.arn
  depends_on      = [aws_iam_role_policy.app]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  placement_constraints {
    type = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(", ", var.vpc_private_subnet_ids)}]"
  }
}

resource "aws_lb_target_group" "main" {
  name     = "${local.resource_id}-main"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = data.aws_vpc.vpc.id
}

resource "aws_lb" "app" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in var.vpc_private_subnet_ids : subnet.id]

  enable_deletion_protection = true

  # TODO
  access_logs {
    bucket  = aws_s3_bucket.lb_logs_bucket.id
    prefix  = "lb-logs-app"
    enabled = true
  }

  tags = {
    Environment = var.environment
  }
}
