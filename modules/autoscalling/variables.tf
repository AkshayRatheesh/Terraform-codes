variable "ami_id" {
    
}
variable "vpc_id" {
  
}
variable "subnet_id" {
  
}

# variable "launch_config_name" {
#   default = "instance_launch_configruation_terraform"
# }

variable "instance_type" {
  default = "t3.micro"
}


#asg section----------------------------------------------

# variable "var.subnet_id" {}
# # variable "var.subnet_id_2" {}
# # variable "placement_group_id" {}
# variable "launch_config_name" {}

# variable "asg_name" {
#   default = "terraform_asg"
# }
# variable "asg_tag_name" {
#   default = "terraform_asg"
# }
# variable "asg_max_size" {
#   default = "2"
# }
# variable "asg_min_size" {
#   default = "1"
# }
# variable "asg_ealth_check_grace_period" {
#   default = "300"
# }
# variable "asg_health_check_type " {
#   default = "EC2"
# }
# variable "asg_desired_capacity" {
#   default = "1"
# }

# variable "asg_force_delete " {
#   default = "true"
# }



