resource "aws_vpc" "cloudops_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cloudops-vpc"
  }
}
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
resource "aws_key_pair" "cloudops_key" {
  key_name   = "cloudops-key"
  public_key = file("C:/Users/AYUSHKA/.ssh/id_ed25519.pub")
}
resource "aws_instance" "cloudops_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  key_name = aws_key_pair.cloudops_key.key_name

  subnet_id                   = aws_subnet.cloudops_subnet.id
  vpc_security_group_ids      = [aws_security_group.cloudops_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker
              systemctl enable docker
              systemctl start docker
              usermod -aG docker ec2-user
              EOF

  tags = {
    Name = "cloudops-ec2"
  }
}
resource "aws_subnet" "cloudops_subnet" {
  vpc_id     = aws_vpc.cloudops_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "cloudops-subnet"
  }
}
resource "aws_internet_gateway" "cloudops_igw" {
  vpc_id = aws_vpc.cloudops_vpc.id

  tags = {
    Name = "cloudops-igw"
  }
}
resource "aws_route_table" "cloudops_route_table" {
  vpc_id = aws_vpc.cloudops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudops_igw.id
  }

  tags = {
    Name = "cloudops-route-table"
  }
}
resource "aws_route_table_association" "cloudops_subnet_association" {
  subnet_id      = aws_subnet.cloudops_subnet.id
  route_table_id = aws_route_table.cloudops_route_table.id
}
resource "aws_security_group" "cloudops_sg" {
  name        = "cloudops-sg"
  description = "Security group for CloudOps EC2"
  vpc_id      = aws_vpc.cloudops_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloudops-sg"
  }
}