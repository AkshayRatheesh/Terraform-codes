
#-------------------------------------------------------------
#virtual private network(vpc)
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = var.vpc_name
    "env"  = var.env_name
  }
}

#-------------------------------------------------------------
#vpc subnet 
resource "aws_subnet" "my_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.subnet_az
  tags = {
    "Name" = var.subnet_name
    "env"  = var.env_name
  }
}

# #vpc subnet 
# resource "aws_subnet" "my_subnet_2" {
#   vpc_id            = var.vpc_id
#   cidr_block        = var.subnet_cidr_block
#   availability_zone = var.subnet_az_a
#   tags = {
#     "Name" = var.subnet_az_b_name
#     "env"  = var.env_name
#   }
# }
#-------------------------------------------------------------
#internet gateway
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = var.vpc_id

  tags = {
    "Name" = var.ig_name
    "env"  = var.env_name
  }
}

#-------------------------------------------------------------
#route table
resource "aws_route_table" "my_route_table" {
  vpc_id = var.vpc_id
  #IPV4 routes 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }
  #IPV6 routes
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = var.internet_gateway_id
  }

  tags = {
    Name  = var.route_table_name
    "env" = var.env_name
  }
}

#-------------------------------------------------------------
#associate subnet with route table
resource "aws_route_table_association" "my_subnet_associate" {
  subnet_id      = var.subnet_id
  route_table_id = var.route_table_id
}

#-------------------------------------------------------------
# network insterface 
resource "aws_network_interface" "my_network_insterface" {
  subnet_id       = var.subnet_id
  private_ips     = [var.private_ips]
  security_groups = [var.security_groups_id]

}

#-------------------------------------------------------------
#elstic ip
resource "aws_eip" "my_ilastic_ip" {
  vpc                       = true
  network_interface         = var.network_insterface_id
  associate_with_private_ip = var.private_ips
  depends_on                = [var.internet_gateway_data]

}

#-------------------------------------------------------------





output "vpc_id" {
  description = "virtual private network id"
  value       = aws_vpc.my_vpc.id
  
}

output "internet_gateway_id" {
  description = "internet gateway id"
  value       = aws_internet_gateway.my_internet_gateway.id
  
  
}

output "internet_gateway_data" {
  description = "internet gateway data"
  value       = aws_internet_gateway.my_internet_gateway
  
  
}

output "route_table_id" {
  description = "route table id"
  value       = aws_route_table.my_route_table.id
  
}

output "network_insterface_id" {
  description = "network insterface id"
  value       = aws_network_interface.my_network_insterface.id
  
}

output "subnet_id" {
  description = "subnets id"
  value       = aws_subnet.my_subnet.id
  
}
