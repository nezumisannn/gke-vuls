terraform {
  backend "s3" {
    bucket = "Your S3 bucket"
    key    = "Your S3 key"
    region = "Your region"
  }
}
