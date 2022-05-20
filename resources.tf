variable "awsprofile" {
  type = string
  default = "jtang-nclouds"
}
########################################################################
#  Provider
########################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "jtang-nclouds-academy-2022"
    key    = "terraform/hw3.tfstate"
    region = "us-west-1"
    dynamodb_table = "jtang-tfstate"
    profile = "jtang-nclouds"
  }
}

provider "aws" {
  region = "us-east-2"
  profile = "${var.awsprofile}"
}

module "vpc" {
  source = "./modules/vpc"
}

module "launchconfig" {
  source = "./modules/launchconfig"
  prefix = module.vpc.prefix
}

module "autoscaling" {
  source = "./modules/autoscaling"
  prefix = module.vpc.prefix
  launch_config_name = module.launchconfig.launch_config_name
  subnet_ids = [module.vpc.privatesubnet1_id, module.vpc.privatesubnet2_id, module.vpc.privatesubnet3_id]
}
