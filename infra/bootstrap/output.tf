output "github_actions_role_arn" {
  description = "github action role ARN"
  value       = aws_iam_role.github_actions_role.arn
}

output "github_oidc_provider_arn" {
  description = "opid provider arn"
  value       = aws_iam_openid_connect_provider.oidc.arn

}