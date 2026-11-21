provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "demo" {
  bucket = "abhay-project12-demo-bucket-1234745"
}

output "bucket_name" {
  value = aws_s3_bucket.demo.bucket
}
