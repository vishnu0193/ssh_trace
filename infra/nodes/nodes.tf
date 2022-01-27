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
    //security_groups_name = [module.sg.vpc_sg_id]
    scope  = var.scope
    key_name = var.key_name
}

module "vms-client" {
    source = "../../modules/ec2"
    instance_type = var.instance_type
    instance_tag  = var.instance_tag_client
    //security_groups_name = [module.sg.vpc_sg_id]
    scope  = var.scope
    key_name = var.key_name
}