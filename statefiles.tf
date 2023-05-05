terraform {
  backend "s3" {
    bucket = "jkterra"
    key    = "project-terra/terraform.tfstate"
    region = "us-east-1"
  }
}