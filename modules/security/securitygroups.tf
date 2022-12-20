#security groups
resource "aws_security_group" "my_security_groups" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id
  #inbound rules 1
  ingress {
    description      = "http allow"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  #inbound rules 2

  ingress {
    description      = "ssh allow"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  #outbond rules
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = var.sg_tag_name
    "env"  = var.env_name
  }
}


output "security_groups_id" {
  description = "security group id"
  value       = aws_security_group.my_security_groups.id
  
}