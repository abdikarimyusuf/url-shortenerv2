terraform {
  backend "s3" {
    bucket       = "url-shortener-bucket-1234567890123"
    key          = "url-shortener/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}