variable "bucket_name" {
  description = "bucket name"
  type        = string
}

variable "price_class" {
  description = "which AWS edge locations CloudFront can use to serve your users."
  type        = string
}

variable "origin_name" {
  description = "alb origin name"
  type        = string
}

variable "cloudfront_certificate_arn" {
  description = "the cloudfront certificate rn"
  type        = string
}

variable "domain_name" {
  description = "domain "
}