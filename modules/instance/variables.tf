variable "ami_id" {}
variable "network_insterface_id" {}
variable "instance_type" {
  default = "t3.micro"
}
variable "availability_zone" {
  default = "ap-south-2a"
}
variable "instance_count" {
  default = "1"
}