output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_zone_id" {
  description = "the cloudfront zone id"
  value       = aws_cloudfront_distribution.frontend.hosted_zone_id
}

output "bucket_name" {
  description = "name of the bucket"
  value       = aws_s3_bucket.frontend.bucket
}

output "distribution_id" {
  value = aws_cloudfront_distribution.frontend.id
}