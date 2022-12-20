#ec2 instance
resource "aws_instance" "my_instance" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  key_name          = "hyd-key"
  count             = var.instance_count
  # subnet_id = var.subnet_az_a_id

  network_interface {
    device_index         = 0
    network_interface_id = var.network_insterface_id
  }
  user_data = filebase64("./userdata.sh")
  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo apt update -y
  #             sudo apt upgrade -y 
  #             sudo apt install nginx -y
  #             sudo systemctl start nginx
  #             EOF
  tags = {
    Name  = "terraform_ec2"
    "env" = "development"
  }
}

# output "instance_id" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.my_instance.id
# }
