# variable "instance_tag" {
#     type = string
#     default = "alphaserver"
# }

# variable "instance_tag_client" {
#     type = string
#     default = "alpha-client-1"
# }


# variable "instance_type"{
#     type = string
#     description = "(optional) describe your variable"
#     default = "t2.micro"
# }

variable "vpc_tag" {
    type = string
    description = "(optional) describe your variable"
    default = "ssh_trace"
}

# variable "key_name" {
#     type = string
#     description = "(optional) describe your variable"
#     default = "ssh_trace"
# }

variable "vpc_name" {
    type = string
    description = "(optional) describe your variable"
    default = "value"
}

# variable "scope" {
#     type = string
#     description = "(optional) describe your variable"
#     default = "ssh_tracing"
# }