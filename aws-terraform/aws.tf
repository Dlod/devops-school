terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  access_key  = "AKIAYH3IOQEKLGY22LEX"
  secret_key  = "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"
  region  = "eu-central-1"
}

resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Web Security Group for HTTP"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    proto       = all
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "builder" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

output "vpc_resource_level_tags" {
  id = aws_instance.builder.id
}