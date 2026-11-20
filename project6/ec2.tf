resource "aws_instance" "web" {
  ami           = "ami-0d49397b762873260"
  instance_type = "t3.micro"
  key_name      = "aj_keypair1"

  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  associate_public_ip_address = true

  user_data = file("${path.module}/install_nginx.sh")

  tags = {
    Name = "terraform-nginx-server"
  }
}
