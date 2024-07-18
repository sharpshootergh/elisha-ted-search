terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "samuel-ofori-tf-s3-backend"
    key    = "tedsearch/dev/state"
    region = "us-east-2"
  }
}
provider "aws" {
  region                   = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
}


resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.tedsearch.id
  iam_instance_profile = data.aws_iam_role.i_am_role.name
  key_name = var.instance_key
  

  vpc_security_group_ids      = [data.aws_security_group.tedsearch.id]
  associate_public_ip_address = true
  tags = {
    Name            = "samuel-ofori-ted-SEARCH-${terraform.workspace}"
    owner           = "Samuel Ofori"
    bootcamp        = "ghana1"
    expiration_date = "28-02-23"
  }
}

resource "null_resource" "docker_setup" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    # private_key = file("~/.ssh/awsUSEast2-keys.pem")  # Locally on my mac
    private_key = file("../../../awsUSEast2-keys.pem") # On my jenkins instance
    host        = aws_instance.this.public_ip
  }


  provisioner "local-exec" {
    command = "mkdir ${var.app_name} && cp -r ../conf ../docker-compose.yml setup.sh init.sh ${var.app_name}/ && zip -r ${var.app_name}.zip ${var.app_name} && rm -r ${var.app_name}/"
  }

  provisioner "file" {
    source      = "./${var.app_name}.zip"
    destination = "/home/ubuntu/${var.app_name}.zip"
  }

  provisioner "remote-exec" {
    
    inline = ["sudo apt install -y unzip", "cd /home/ubuntu/", 
    "unzip ${var.app_name}.zip", "cd ${var.app_name}/", 
    "chmod +x setup.sh", "bash setup.sh", 
     "rm -rf aws*"]
  }

  provisioner "remote-exec" {
    
    inline = ["cd /home/ubuntu/${var.app_name}/", "chmod +x init.sh", "bash init.sh" ]
    
  }
}
