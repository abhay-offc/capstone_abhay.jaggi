# Get default VPC

data "aws_vpc" "default" {
  default = true
}

# Latest Ubuntu 24.04 LTS

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# IAM Role

resource "aws_iam_role" "cw_role" {
  name = "cw-agent-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach CloudWatch Policy

resource "aws_iam_role_policy_attachment" "cw_policy" {
  role       = aws_iam_role.cw_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance Profile

resource "aws_iam_instance_profile" "cw_profile" {
  name = "cw-profile"
  role = aws_iam_role.cw_role.name
}

# Security Group

resource "aws_security_group" "cw_sg" {
  name        = "cw-agent-sg"
  description = "SSH Access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cw-agent-sg"
  }
}

# EC2 Instance

resource "aws_instance" "cloudwatch_lab" {

  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  key_name             = "aj_keypair1"
  iam_instance_profile = aws_iam_instance_profile.cw_profile.name

  vpc_security_group_ids = [
    aws_security_group.cw_sg.id
  ]

  tags = {
    Name = "cloudwatch-lab"
  }
}

output "instance_id" {
  value = aws_instance.cloudwatch_lab.id
}

output "public_ip" {
  value = aws_instance.cloudwatch_lab.public_ip
}
