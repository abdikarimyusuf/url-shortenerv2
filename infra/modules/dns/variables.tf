variable "domain_name" {
  description = "root domain name"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "cloudfront dns name"
  type        = string
}

variable "cloudfront_zone_id" {
  description = "cloudfront zone id  zone id "
  type        = string
}

variable "subdomain" {
  description = "subdomain for the application"
  type        = string
}

variable "alb_dns_name" {
  description = "alb dns name"
  type        = string
}

variable "alb_zone_id" {
  description = "alb zone id"
  type        = string
}







