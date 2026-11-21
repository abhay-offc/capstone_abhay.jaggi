
provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "demo" {
  bucket = "project7-demo-bucket-471281"

  tags = {
    Name        = "Project7Bucket"
    Environment = "Dev"
  }
}

