provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "web_sg" {
  name = "yosh-chaos-test-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "web" {
  ami           = "ami-02f853b31ccb5871f"
  instance_type = "t2.micro"
  key_name      = "aj_keypair1"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
#!/bin/bash
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
EOF

  tags = {
    Name = "yosh-chaos-test-server"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
