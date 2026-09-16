output "repository_url" {
  value       = { for key, repo in aws_ecr_repository.url_shortener : key => repo.repository_url }
  description = "The URL of the ECR repository"
}