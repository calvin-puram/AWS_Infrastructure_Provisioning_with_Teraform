terraform {
  backend "s3" {
    bucket         = "webapp-terraform-bend-job2ko"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "TerraformState-LockedIn"
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "myapp_vpc" {
  cidr_block       = var.vpc_cidr_block
  
  tags = {
    Name = "${var.vpc_dev}-myapp_vpc"
  }
}


module "subnet" {
  source = "./modules/subnet"
  vpc_id = aws_vpc.myapp_vpc.id
  vpc_subnet_cidr = var.vpc_subnet_cidr
  az = var.az
  vpc_dev = var.vpc_dev
  default_rt_id = aws_vpc.myapp_vpc.default_route_table_id
  
}


module "webapp" {
  source = "./modules/webapp"
  vpc_id = aws_vpc.myapp_vpc.id
  my_ip = var.my_ip
  aws_image = var.aws_image
  public_key_name = var.public_key_name
  az = var.az
  vpc_dev = var.vpc_dev
  subnet_id = module.subnet.subnets.id
  
}

