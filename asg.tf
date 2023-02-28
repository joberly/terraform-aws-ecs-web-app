# ECS cluster instance image
data "aws_ami" "amzn2_ecs" {
  executable_users = ["self"]
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*"]
  }
}

# EC2 cluster main auto scaling group
resource "aws_auto_scaling_group" "ecs_main" {
  name_prefix = "${local.resource_id}-ecs-main-"

  desired_capacity = 1

  min_size = 1
  max_size = var.asg_max_size

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      current_size,
    ]
  }
}

# ECS cluster instance launch template
resource "aws_launch_template" "ecs_main" {
  name_prefix = "${local.resource_id}-ecs-main-"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 100
    }
  }

  ebs_optimized = true

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }

  image_id = data.aws_ami.amzn2_ecs.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.instance_type

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
  }

  vpc_security_group_ids = var.vpc_security_group_ids

  tag_specifications {
    resource_type = "instance"

    tags = local.tags
  }
}
