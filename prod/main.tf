terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1" #aws region code
}



#m1-----------------------------------------------------------------------------------------
module "instance_module" {
  source = "../modules/instance"

  ami_id                = "ami-0d8d9a2de1bcdb066"
  instance_type         = "t3.micro"
  availability_zone     = "ap-south-2a"
  instance_count        = "1"
  network_insterface_id = module.network_module.network_insterface_id #dynamic
}


#m2-----------------------------------------------------------------------------------------
module "network_module" {
  source = "../modules/network"

  env_name       = "production"
  vpc_id         = module.network_module.vpc_id #dynamic
  vpc_name       = "production_terraform_vpc"
  vpc_cidr_block = "10.0.0.0/16"
  subnet_name    = "production_terraform_subnet_a"
  #subnet_az_b_name      = "terraform_subnet_b"
  subnet_id = module.network_module.subnet_id #dynamic
  #subnet_az_b_id        = ""                                   #dynamic
  subnet_cidr_block = "10.0.1.0/24"
  subnet_az         = "ap-south-2a"
  #subnet_az_b           = "ap-south-2b"
  ig_name               = "production_terraform_ig"
  internet_gateway_id   = module.network_module.internet_gateway_id   #dynamic
  internet_gateway_data = module.network_module.internet_gateway_data #dynamic
  route_table_name      = "production_terraform_route_table"
  route_table_id        = module.network_module.route_table_id #dynamic
  private_ips           = "10.0.1.50"
  network_insterface_id = module.network_module.network_insterface_id #dynamic
  security_groups_id    = module.secutity_module.security_groups_id   #dynamic
}


#m3-----------------------------------------------------------------------------------------
module "secutity_module" {
  source = "../modules/security"

  env_name           = "production"
  vpc_id             = module.network_module.vpc_id #dynamic
  sg_name            = "production_terraform_sg"
  sg_tag_name        = "production_terraform_sg"
  security_groups_id = module.secutity_module.security_groups_id #dynamic
}


#m4-----------------------------------------------------------------------------------------


module "asg_module" {
  source = "../modules/autoscalling"
  ami_id = "ami-0d8d9a2de1bcdb066"
  vpc_id             = module.network_module.vpc_id
  subnet_id = module.network_module.subnet_id 
}




#m5-----------------------------------------------------------------------------------------


module "s3_module" {
  source         = "../modules/s3bucket"
  s3_bucket_name = "production_thisisbucketterraform123"
  s3_tag_name    = "production_s3_terraform"
  env_name       = "production"
}
