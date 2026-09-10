resource "aws_ecr_repository" "url_shortener" {
    for_each = var.repositories
  name = "${var.project_name}-${var.environment}-${each.key}"
  image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
        scan_on_push = true
    }
  tags = {
    Name = "${var.project_name}-${var.environment}-${each.key}"
  }
}

resource "aws_ecr_lifecycle_policy" "url_shortener" {
  for_each = aws_ecr_repository.url_shortener
  repository = aws_ecr_repository.url_shortener[each.key].name
  policy     = data.template_file.lifecycle_policy[each.key].rendered
}