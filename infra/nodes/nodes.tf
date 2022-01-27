provider "aws" {
  region = "us-east-1"
}
module "vpc" {
    source = "../../modules/networking"
    vpc_tag = var.vpc_tag    
}

module "sg" {
source = "../../modules/sgroups" 
vpc_id = module.vpc.vpc_ssh_id
depends_on = [
  module.vpc 
  ]
}


module "vms-server" {
    source = "../../modules/ec2"
    instance_type = var.instance_type
    instance_tag  = var.instance_tag
    scope  = var.scope
    key_name = var.key_name
}

module "vms-client-1" {
    source = "../../modules/ec2"
    instance_type = var.instance_type
    instance_tag  = var.instance_tag_client
    scope  = var.scope
    key_name = var.key_name
}


module "vms-client-2" {
    source = "../../modules/ec2"
    instance_type = var.instance_type
    instance_tag  = var.instance_tag_client_2
    scope  = var.scope
    key_name = var.key_name
}
