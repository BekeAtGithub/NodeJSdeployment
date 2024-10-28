provider "aws" {
  region = "us-east-1"  # Change this to your preferred AWS region
}

resource "aws_instance" "nodejs_app" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI in us-east-1 (update based on your region)
  instance_type = "t2.micro"

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
              git clone https://github.com/your-username/your-repo.git /home/ec2-user/nodejs_app
              cd /home/ec2-user/nodejs_app

              # Install app dependencies
              npm install

              # Start the app
              npm install pm2 -g
              pm2 start app.js --name nodejs_app
              pm2 startup
              pm2 save
              EOF

  # Security Group to allow HTTP traffic
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  tags = {
    Name = "NodeJSAppInstance"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"

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

output "public_ip" {
  value = aws_instance.nodejs_app.public_ip
  description = "The public IP address of the Node.js app instance."
}

output "app_url" {
  value = "http://${aws_instance.nodejs_app.public_ip}"
  description = "The URL to access the Node.js app."
}
