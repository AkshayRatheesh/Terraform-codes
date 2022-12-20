variable "env_name" {}

#vpc section----------------------------------------

variable "vpc_id" {}
variable "vpc_name" {}

variable "vpc_cidr_block" {
  default = "10.0.1.0/16"
}

#subnet section-------------------------------------

variable "subnet_name" {}
# variable "subnet_az_b_name" {}
variable "subnet_id" {}
# variable "subnet_az_b_id" {
#   default = ""
# }

variable "subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "subnet_az" {
  default = "ap-south-2a"
}
# variable "subnet_az_b" {
#   default = "ap-south-2b"
# }

#internet gateway----------------------------------

variable "ig_name" {}
variable "internet_gateway_id" {}
variable "internet_gateway_data" {}
#route table---------------------------------------

variable "route_table_name" {}
variable "route_table_id" {}

#network_insterface---------------------------------

variable "private_ips" {}
variable "network_insterface_id" {}

variable "security_groups_id" {}







