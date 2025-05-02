terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_instance" "jef_mongodb" {
  ami = "ami-0d866da98d63e2b42"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_group_mongodb.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y mongodb
              sudo systemctl start mongodb
              sudo systemctl enable mongodb
              EOF

}

resource "aws_security_group" "security_group_mongodb" {
  name        = "security_group_mongodb"
  description = "permitir acesso http e acesso a internet"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}