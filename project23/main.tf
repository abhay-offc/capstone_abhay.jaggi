provider "aws" {
  region = "ap-south-1"
}
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
resource "aws_security_group" "ec2_sg" {
  name        = "iam-role-demo-sg-yoshi"
  description = "Allow SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-s3-role-yoshi"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}


resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "profile" {
  name = "ec2-s3-profile-yoshi"
  role = aws_iam_role.ec2_s3_role.name
}



resource "aws_instance" "demo" {
  ami                    = "ami-02f853b31ccb5871f"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "aj_keypair1"

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.profile.name

  tags = {
    Name = "yoshi-iam-role-demo"
  }
}

output "public_ip" {
  value = aws_instance.demo.public_ip
}
