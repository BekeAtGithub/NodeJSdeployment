provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

# Create a custom VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custom_vpc"
  }
}

# Create a custom subnet within the VPC
resource "aws_subnet" "custom_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # Adjust based on region
  map_public_ip_on_launch = true
  tags = {
    Name = "custom_subnet"
  }
}

# Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "custom_igw"
  }
}

# Create a custom route table for the VPC
resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "custom_route_table"
  }
}

# Create a route in the route table to direct traffic to the internet gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.custom_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.custom_igw.id
}

# Associate the route table with the subnet
resource "aws_route_table_association" "custom_route_table_association" {
  subnet_id      = aws_subnet.custom_subnet.id
  route_table_id = aws_route_table.custom_route_table.id
}

# Create a security group that allows HTTP and SSH access
resource "aws_security_group" "allow_http_ssh" {
  vpc_id = aws_vpc.custom_vpc.id
  name   = "allow_http_ssh"

  # Allow HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}

# Find the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Launch an EC2 instance in the custom VPC and subnet
resource "aws_instance" "nodejs_app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.custom_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  # User data script to install Node.js and run the app
  user_data = <<-EOF
              #!/bin/bash
              # Update and install dependencies
              sudo yum update -y
              sudo yum install -y curl

              # Install Node.js
              curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
              sudo yum install -y nodejs

              # Install Git and clone the application repository
              sudo yum install -y git
              git clone https://github.com/BekeAtGithub/NodeJSdeployment.git /home/ec2-user/nodejs_app
              cd /home/ec2-user/nodejs_app

              # Install app dependencies
              npm install

              # Start the app
              npm install pm2 -g
              pm2 start app.js --name nodejs_app
              pm2 startup
              pm2 save
              EOF

  tags = {
    Name = "NodeJSAppInstance"
  }
}

# Output the public IP and URL
output "public_ip" {
  value       = aws_instance.nodejs_app.public_ip
  description = "The public IP address of the Node.js app instance."
}

output "app_url" {
  value       = "http://${aws_instance.nodejs_app.public_ip}"
  description = "The URL to access the Node.js app."
}
