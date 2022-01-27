


data "aws_vpc" "selected" {
  id = var.vpc_id
}
resource "aws_security_group" "allow_from_pc" {
  name        = "ssh_tracing"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.selected.id 

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.selected.cidr_block]//[data.aws_vpc.selected.id.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh_trace"
  }
}