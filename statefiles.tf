terraform {
  backend "s3" {
    bucket = "jkterra"
    key    = "jkterra/dev/terraform.tfstate"
    region = "us-east-1"
  }
}