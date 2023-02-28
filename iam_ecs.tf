# ECS cluster instance IAM profile
resource "aws_iam_instance_profile" "ecs" {
  name = "${local.resource_id}-ecs"
  role = aws_iam_role.main.name

  tags = local.tags
}

# ECS cluster instance role
resource "aws_iam_role" "ecs" {
  name = "${local.resource_id}-ecs-instance"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = local.tags
}

# ECS cluster instance role policy attachments
resource "aws_iam_role_policy_attachment" "ecs" {
  for_each = data.aws_iam_policy.ecs

  role       = aws_iam_role.main.name
  policy_arn = each.value.arn
}

# ECS cluster instance role 
data "aws_iam_policy" "ecs" {
  for_each = toset([
    "AmazonEC2ContainerServiceforEC2Role",
  ])

  name = each.key
}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principal {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}
