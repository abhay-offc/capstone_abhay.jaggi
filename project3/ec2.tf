provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "test" {
  ami           = "ami-0dc0718b8dd0dedd8"
  instance_type = "t3.micro"
  key_name = "aj_keypair1"
  user_data = <<-EOF
  #!/bin/bash
  nohup yes > /dev/null &
  EOF
  tags = {
    Name = "cloudwatch-test-instance"
  }
}

output "instance_id" {
  value = aws_instance.test.id
}

output "public_ip" {
  value = aws_instance.test.public_ip
}
