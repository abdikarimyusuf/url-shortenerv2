output "ecr_api_endpoint_id" {
    value = aws_vpc_endpoint.ecr_api.id
    description = "VPC Endpoint ID for ECR API"
}

output "ecr_dkr_endpoint_id" {
    value = aws_vpc_endpoint.ecr_dkr.id
    description = "VPC Endpoint ID for ECR DKR"
}

output "s3_endpoint_id" {
    value = aws_vpc_endpoint.s3.id
    description = "VPC Endpoint ID for S3"
}

output "logging_endpoint_id" {
    value = aws_vpc_endpoint.logging.id
    description = "VPC Endpoint ID for Logging"
}

output "secretsmanager_endpoint_id" {
    value = aws_vpc_endpoint.secretsmanager.id
    description = "VPC Endpoint ID for Secrets Manager"
}

output "sqs_endpoint_id" {
    value = aws_vpc_endpoint.sqs.id
    description = "VPC Endpoint ID for SQS"
}