terraform {
  backend "s3" {
    bucket = "jkterra"
    key    = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}