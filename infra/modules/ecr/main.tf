resource "aws_ecr_repository" "url_shortener" {
  for_each             = var.repositories
  name                 = "${var.project_name}-${var.environment}-${each.key}"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-${each.key}"
  }
}

resource "aws_ecr_lifecycle_policy" "url_shortener" {
  for_each   = aws_ecr_repository.url_shortener
  repository = aws_ecr_repository.url_shortener[each.key].name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 20 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 20
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}