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

data "aws_instance" "server" {
filter {
    name   = "tag:Name"
    values = ["alphaserver"]
  }
  depends_on = [
    module.vms-server
  ]
}

data "aws_instance" "client1" {
filter {
    name   = "tag:Name"
    values = ["alpha-client-1"]
  }
  depends_on = [
    module.vms-client-1
  ]
}
## Copying the source code to the backend server
resource "null_resource" "ec2-ssh-connection" {
  provisioner "file" {
    source      = "../../src"
    destination = "/home/ubuntu/"
    connection {
      host        = data.aws_instance.server.public_ip
      type        = "ssh"
      port        = 22
      user        = "ubuntu"
      private_key = "${file("~/xxx/xxx.pem")}"
      timeout     = "1m"
      agent       = false
    }
  }
}
# Deploying the code as cronjobs
resource "null_resource" "ec2-ssh-connection-script-deploy" {
    triggers = {
    always_run = timestamp()
  }
  provisioner "remote-exec" {
    connection {
      host        = data.aws_instance.server.public_ip
      type        = "ssh"
      port        = 22
      user        = "ubuntu"
      private_key = "${file("~/xxx/xxx.pem")}"
      timeout     = "1m"
      agent       = false
    }
  inline = [
      "chmod +x /home/ubuntu/src/*",
      "crontab -r",
      "rm -r /home/ubuntu/ssh_success.log",
      "(crontab -l 2>/dev/null; echo '* * * * * /home/ubuntu/src/ssh_trace_success.sh >> /home/ubuntu/ssh_success.log') | crontab -",
    ]
  }
}
# copying the pem files for client communications to server
resource "null_resource" "ec2-ssh-key-copy-client-1" {
  provisioner "file" {
    source      = "~/xxxx/xxx.pem"
    destination = "/home/ubuntu/ssh.pem"
    connection {
      host        = data.aws_instance.client1.public_ip
      type        = "ssh"
      port        = 22
      user        = "ubuntu"
      private_key = "${file("~/xxxx/xxx.pem")}"
      timeout     = "1m"
      agent       = false
    }
  }
}

# Performing ssh from the client to the server
resource "null_resource" "ec2-ssh-connection-client-1" {
 triggers = {
    always_run = timestamp()
  }
  provisioner "remote-exec" {
    connection {
      host        = data.aws_instance.client1.public_ip
      type        = "ssh"
      port        = 22
      user        = "ubuntu"
      private_key = "${file("~/xxx/xxx.pem")}"
      timeout     = "1m"
      agent       = false
    }
  inline = [
      "cd /home/ubuntu",
      "chmod 400 ssh.pem",
      "ssh -i /home/ubuntu/ssh.pem ubuntu@${data.aws_instance.server.private_ip} -f 'sleep 2s ; exit'",
    ]
  }
}

resource "time_sleep" "wait_60" {
  create_duration = "60s"
}

# Displays the output of the attempts made by the client on the server
resource "null_resource" "display-output" {
  triggers = {
    always_run = timestamp()
  }
  depends_on = [time_sleep.wait_60]
  provisioner "remote-exec" {
    connection {
      host        = data.aws_instance.server.public_ip
      type        = "ssh"
      port        = 22
      user        = "ubuntu"
      private_key = "${file("~/xx/xxx.pem")}"
      timeout     = "1m"
      agent       = false
    }
  inline = [
      "echo 'sleeping for 10 s' ",
      "cat /home/ubuntu/ssh_success.log"
    ]
  }
}