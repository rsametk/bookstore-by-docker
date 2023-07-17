terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "github" {
  token = "********************"
}
resource "github_repository" "myrepo" {
  name        = "bookstoreapi"
  visibility = "private"
  auto_init   = true
}
resource "github_branch_default" "default"{
  repository = github_repository.myrepo.name
  branch     = "main"
}
variable "files" {
  default = ["bookstore-api.py", "docker-compose.yaml", "Dockerfile", "requirements.txt"]
}
resource "github_repository_file" "app-file" {
  for_each = toset(var.files)
  repository          = github_repository.myrepo.name
  branch              = "main"
  file                = each.value
  content             = file(each.value)
  commit_message      = "Managed by Terraform"
  overwrite_on_create = true
}
resource "aws_instance" "tf-instance" {
  ami = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"
  key_name = "polat"
  vpc_security_group_ids = [ aws_security_group.tf-sec-gr.id ]
  tags = {
    Name = "bookstore-instance"
  }
  user_data = <<-EOF
    #! /bin/bash
    yum update -y
    yum install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user
    newgrp docker
    curl -SL https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    mkdir -p /home/ec2-user/bookstore-api
    TOKEN="***********************"
    FOLDER="https://$TOKEN@raw.githubusercontent.com/pol-ayt/bookstoreapi/main/"
    curl -s --create-dirs -o "/home/ec2-user/bookstore-api/app.py" -L "$FOLDER"bookstore-api.py
    curl -s --create-dirs -o "/home/ec2-user/bookstore-api/requirements.txt" -L "$FOLDER"requirements.txt
    curl -s --create-dirs -o "/home/ec2-user/bookstore-api/Dockerfile" -L "$FOLDER"Dockerfile
    curl -s --create-dirs -o "/home/ec2-user/bookstore-api/docker-compose.yaml" -L "$FOLDER"docker-compose.yaml
    cd /home/ec2-user/bookstore-api
    docker build -t polatdocker/bookstore:latest .
    docker-compose up -d
  EOF
  depends_on = [ github_repository.myrepo, github_branch_default.default ]
}
resource "aws_security_group" "tf-sec-gr" {
  ingress {
    from_port = 22terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source = "integrations/github"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
provider "github" {
  token = "*****************"  #do not forget to add your token 
}
resource "github_repository" "myrepo" {
  name        = "bookstoreapi"
  visibility = "private"
  auto_init   = true
}
resource "github_branch_default" "default"{
  repository = github_repository.myrepo.name
  branch     = "main"
}
variable "files" {
  default = ["bookstore-api.py", "docker-compose.yaml", "Dockerfile", "requirements.txt"]
}
resource "github_repository_file" "app-file" {
  for_each = toset(var.files)
  repository          = github_repository.myrepo.name
  branch              = "main"
  file                = each.value
  content             = file(each.value)
  commit_message      = "Managed by Terraform"
  overwrite_on_create = true
}
resource "aws_instance" "tf-instance" {
  ami = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"
  key_name = "polat"
  vpc_security_group_ids = [ aws_security_group.tf-sec-gr.id ]
  tags = {
    Name = "bookstore-instance"
  }
  user_data = <<-EOF
    #! /bin/bash
    yum update -y
    yum install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user
    newgrp docker
    curl -SL https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    mkdir -p /home/ec2-user/bookstore-api
    TOKEN="*****************************"
    FOLDER="https://$TOKEN@raw.githubusercontent.com/pol-ayt/bookstoreapi/main/"
    curl -s --create-dirs -o "/home/ec2-user/bookstore-api/app.py" -L "$FOLDER"bookstore-api.py
    curl -s --create-dirs -o "/home/ec2-user/bookstore-api/requirements.txt" -L "$FOLDER"requirements.txt
    curl -s --create-dirs -o "/home/ec2-user/bookstore-api/Dockerfile" -L "$FOLDER"Dockerfile
    curl -s --create-dirs -o "/home/ec2-user/bookstore-api/docker-compose.yaml" -L "$FOLDER"docker-compose.yaml
    cd /home/ec2-user/bookstore-api
    docker build -t polatdocker/bookstore:latest .
    docker-compose up -d
  EOF
  depends_on = [ github_repository.myrepo, github_branch_default.default ]
}
resource "aws_security_group" "tf-sec-gr" {
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
output "webpage" {
  value = "http://${aws_instance.tf-instance.public_ip}"
}
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
output "webpage" {
  value = "http://${aws_instance.tf-instance.public_ip}"
}