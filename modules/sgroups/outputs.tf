output "vpc_sg_id" {
    value = aws_security_group.allow_from_pc.id
}