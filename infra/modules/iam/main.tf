data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }

}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.project_name}-${var.environment}-ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    name = "${var.project_name}-${var.environment}-ecs-task-execution"
  }

}

resource "aws_iam_role_policy_attachment" "ecs-task-execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

resource "aws_iam_role_policy" "ecs_secrets" {
  name = "${var.project_name}-${var.environment}-ecs_secrets"
  role = aws_iam_role.ecs_task_execution.id
  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = var.database_secret_arn
      }
    ]
  })
}

resource "aws_iam_role" "api_task" {
  name               = "${var.project_name}-${var.environment}-api_task_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
  tags = {
    name = "${var.project_name}-${var.environment}-api-task-role"
  }


}

data "aws_iam_policy_document" "api_task" {
  statement {
    sid    = "AllowPublicClickEvents"
    effect = "Allow"
    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      var.sqs_queue_arn
    ]
  }

  statement {
    sid    = "ReadRDSCredentials"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      var.database_secret_arn
    ]
  }

}

resource "aws_iam_role_policy" "api_task_inline_policy" {
  name   = "${var.project_name}-${var.environment}-api_task_inline_policy"
  role   = aws_iam_role.api_task.id
  policy = data.aws_iam_policy_document.api_task.json

}


resource "aws_iam_role" "worker_role" {
  name               = "${var.project_name}-${var.environment}-worker_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
  tags = {
    name = "${var.project_name}-${var.environment}-worker_role"
  }

}

data "aws_iam_policy_document" "worker_policy" {
  statement {
    sid    = "AllowPublicClickEvents"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:DeleteMessage",
      "sqs:ChangeMessageVisibility",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage"

      #least privilege.
    ]

    resources = [
      var.sqs_queue_arn
    ]
  }
  statement {
    sid    = "ReadRDSCredentials"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      var.database_secret_arn
    ]
  }

}


resource "aws_iam_role_policy" "worker_task_inline_policy" {
  name   = "${var.project_name}-${var.environment}-worker_task_inline_policy"
  role   = aws_iam_role.worker_role.id
  policy = data.aws_iam_policy_document.worker_policy.json

}


resource "aws_iam_role" "dashboard_role" {
  name               = "${var.project_name}-${var.environment}-inline-dashboard-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
  tags = {
    name = "${var.project_name}-${var.environment}-dashboard_role"
  }

}

data "aws_iam_policy_document" "ecs_secret_policy" {
  statement {
    sid    = "ReadRDSCredentials"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
      #least privilege.
    ]

    resources = [
      var.database_secret_arn
    ]
  }

}

resource "aws_iam_role_policy" "dashboard_task_inline_policy" {
  name   = "${var.project_name}-${var.environment}-inline-ecs-secret"
  role   = aws_iam_role.ecs_task_execution.id
  policy = data.aws_iam_policy_document.ecs_secret_policy.json

}






