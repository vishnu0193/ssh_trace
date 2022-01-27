provider "aws" {
  region = "us-east-1"
}
module "vpc" {
    source = "../../modules/networking"
    vpc_tag = var.vpc_tag    
}

