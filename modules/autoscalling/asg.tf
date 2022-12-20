<<<<<<< HEAD
# # resource "aws_launch_template" "my_launch_config" {
# #   name_prefix   = var.launch_config_name
# #   image_id      = var.ami_id
# #   instance_type = var.instance_type
# # }


# resource "aws_launch_configuration" "my_launch_config" {
#   name          = var.launch_config_name
#   image_id      = var.ami_id
#   instance_type = "t3.micro"
# }
# #asg section----------------------------------------------

# # resource "aws_autoscaling_group" "my_asg" {
# #   name                      = var.asg_name 
# #   max_size                  = var.asg_max_size
# #   min_size                  = var.asg_min_size
# #   health_check_grace_period = var.asg_ealth_check_grace_period
# #   health_check_type         = var.asg_health_check_type 
# #   desired_capacity          = var.asg_desired_capacity
# #   force_delete              = var.asg_force_delete 
# # #   placement_group           = var.placement_group_id
# #   launch_configuration      = var.launch_config_name
# #   vpc_zone_identifier       = [var.subnet_id]#  vpc_zone_identifier       = [var.subnet_id_1, var.subnet_id_2]


    
# #   tag {
# #     Name                 = var.asg_tag_name
# #     env               = var.env_name
# #   }
# # }

# # resource "aws_autoscaling_policy" "my_asg_policy" {
# #   name = var.asg_policy_name
# #   autoscaling_group_name = var.asg_name
# #   adjustment_type = "ChangeInCapacity"
# #   scaling_adjustment = 1
# #   cooldown = 30
# #   policy_type = "SimpleScaling"
# # }

# # resource "aws_cloudwatch_metric_alarm" "my_cloudwatch" {
# #   alarm_name                = "terraform-test-foobar5"
# #   comparison_operator       = "GreaterThanOrEqualToThreshold"
# #   evaluation_periods        = "2"
# #   metric_name               = "CPUUtilization"
# #   namespace                 = "AWS/EC2"
# #   period                    = "120"
# #   statistic                 = "Average"
# #   threshold                 = "80"
# #   alarm_description         = "This metric monitors ec2 cpu utilization"
  
# #   dimensions = {
# #     "AutoScallingGroupname" = var.asg_name
# #   }
# #   actions_enabled = true
# #   alarm_action = var.my_asg_policy_arn
# # }



# ## Creating AutoScaling Group
# resource "aws_autoscaling_group" "example" {
#   launch_configuration = aws_launch_configuration.my_launch_config.id###
#   availability_zones = ["ap-south-2a"]
#   min_size = 1
#   max_size = 2
#   load_balancers = [aws_elb.example.name]
#   health_check_type = "ELB"
#   tag {
#     key = "Name"
#     value = "terraform-asg-example"
#     propagate_at_launch = true
#   }
# }
# ## Security Group for ELB
# resource "aws_security_group" "elb" {
#   name = "terraform-example-elb"
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
# ### Creating ELB
# resource "aws_elb" "example" {
#   name = "terraform-asg-example"
#   security_groups = [aws_security_group.elb.id]
#   availability_zones = ["ap-south-2a"]
#   health_check {
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#     timeout = 3
#     interval = 30
#     target = "HTTP:8080/"
#   }
#   listener {
#     lb_port = 80
#     lb_protocol = "http"
#     instance_port = "8080"
#     instance_protocol = "http"
#   }
# }


resource "aws_launch_configuration" "web" {
  name_prefix = "web-"

  image_id = var.ami_id# Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  key_name = "hyd-key"

  security_groups = [ aws_security_group.elb_http.id ]
  associate_public_ip_address = true


  lifecycle {
    create_before_destroy = true
  }
}


#####

resource "aws_security_group" "elb_http" {
  name        = "elb_http"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP through ELB Security Group"
  }
}

resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
    aws_security_group.elb_http.id
  ]
  subnets = [
   
    var.subnet_id
  ]

  cross_zone_load_balancing   = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }

}













# resource "aws_autoscaling_group" "web" {
#   name = "${aws_launch_configuration.web.name}-asg"

#   min_size             = 1
#   desired_capacity     = 1
#   max_size             = 2
  
#   health_check_type    = "ELB"
#   load_balancers = [
#     aws_elb.web_elb.id
#   ]

#   launch_configuration = aws_launch_configuration.web.name

#   enabled_metrics = [
#     "GroupMinSize",
#     "GroupMaxSize",
#     "GroupDesiredCapacity",
#     "GroupInServiceInstances",
#     "GroupTotalInstances"
#   ]

#   metrics_granularity = "1Minute"

#   vpc_zone_identifier  = [
    
#     var.subnet_id
#   ]

#   # Required to redeploy without an outage.
#   lifecycle {
#     create_before_destroy = true
#   }

#   tag {
#     key                 = "Name"
#     value               = "web"
#     propagate_at_launch = true
#   }

# }







# resource "aws_autoscaling_policy" "web_policy_up" {
#   name = "web_policy_up"
#   scaling_adjustment = 1
#   adjustment_type = "ChangeInCapacity"
#   cooldown = 300
#   autoscaling_group_name = aws_autoscaling_group.web.name
# }

# resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
#   alarm_name = "web_cpu_alarm_up"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods = "2"
#   metric_name = "CPUUtilization"
#   namespace = "AWS/EC2"
#   period = "120"
#   statistic = "Average"
#   threshold = "60"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.web.name
#   }

#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions = [ aws_autoscaling_policy.web_policy_up.arn ]
=======
# # resource "aws_launch_template" "my_launch_config" {
# #   name_prefix   = var.launch_config_name
# #   image_id      = var.ami_id
# #   instance_type = var.instance_type
# # }


# resource "aws_launch_configuration" "my_launch_config" {
#   name          = var.launch_config_name
#   image_id      = var.ami_id
#   instance_type = "t3.micro"
# }
# #asg section----------------------------------------------

# # resource "aws_autoscaling_group" "my_asg" {
# #   name                      = var.asg_name 
# #   max_size                  = var.asg_max_size
# #   min_size                  = var.asg_min_size
# #   health_check_grace_period = var.asg_ealth_check_grace_period
# #   health_check_type         = var.asg_health_check_type 
# #   desired_capacity          = var.asg_desired_capacity
# #   force_delete              = var.asg_force_delete 
# # #   placement_group           = var.placement_group_id
# #   launch_configuration      = var.launch_config_name
# #   vpc_zone_identifier       = [var.subnet_id]#  vpc_zone_identifier       = [var.subnet_id_1, var.subnet_id_2]


    
# #   tag {
# #     Name                 = var.asg_tag_name
# #     env               = var.env_name
# #   }
# # }

# # resource "aws_autoscaling_policy" "my_asg_policy" {
# #   name = var.asg_policy_name
# #   autoscaling_group_name = var.asg_name
# #   adjustment_type = "ChangeInCapacity"
# #   scaling_adjustment = 1
# #   cooldown = 30
# #   policy_type = "SimpleScaling"
# # }

# # resource "aws_cloudwatch_metric_alarm" "my_cloudwatch" {
# #   alarm_name                = "terraform-test-foobar5"
# #   comparison_operator       = "GreaterThanOrEqualToThreshold"
# #   evaluation_periods        = "2"
# #   metric_name               = "CPUUtilization"
# #   namespace                 = "AWS/EC2"
# #   period                    = "120"
# #   statistic                 = "Average"
# #   threshold                 = "80"
# #   alarm_description         = "This metric monitors ec2 cpu utilization"
  
# #   dimensions = {
# #     "AutoScallingGroupname" = var.asg_name
# #   }
# #   actions_enabled = true
# #   alarm_action = var.my_asg_policy_arn
# # }



# ## Creating AutoScaling Group
# resource "aws_autoscaling_group" "example" {
#   launch_configuration = aws_launch_configuration.my_launch_config.id###
#   availability_zones = ["ap-south-2a"]
#   min_size = 1
#   max_size = 2
#   load_balancers = [aws_elb.example.name]
#   health_check_type = "ELB"
#   tag {
#     key = "Name"
#     value = "terraform-asg-example"
#     propagate_at_launch = true
#   }
# }
# ## Security Group for ELB
# resource "aws_security_group" "elb" {
#   name = "terraform-example-elb"
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
# ### Creating ELB
# resource "aws_elb" "example" {
#   name = "terraform-asg-example"
#   security_groups = [aws_security_group.elb.id]
#   availability_zones = ["ap-south-2a"]
#   health_check {
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#     timeout = 3
#     interval = 30
#     target = "HTTP:8080/"
#   }
#   listener {
#     lb_port = 80
#     lb_protocol = "http"
#     instance_port = "8080"
#     instance_protocol = "http"
#   }
# }


resource "aws_launch_configuration" "web" {
  name_prefix = "web-"

  image_id = var.ami_id# Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  key_name = "hyd-key"

  security_groups = [ aws_security_group.elb_http.id ]
  associate_public_ip_address = true


  lifecycle {
    create_before_destroy = true
  }
}


#####

resource "aws_security_group" "elb_http" {
  name        = "elb_http"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP through ELB Security Group"
  }
}

resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
    aws_security_group.elb_http.id
  ]
  subnets = [
   
    var.subnet_id
  ]

  cross_zone_load_balancing   = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }

}













# resource "aws_autoscaling_group" "web" {
#   name = "${aws_launch_configuration.web.name}-asg"

#   min_size             = 1
#   desired_capacity     = 1
#   max_size             = 2
  
#   health_check_type    = "ELB"
#   load_balancers = [
#     aws_elb.web_elb.id
#   ]

#   launch_configuration = aws_launch_configuration.web.name

#   enabled_metrics = [
#     "GroupMinSize",
#     "GroupMaxSize",
#     "GroupDesiredCapacity",
#     "GroupInServiceInstances",
#     "GroupTotalInstances"
#   ]

#   metrics_granularity = "1Minute"

#   vpc_zone_identifier  = [
    
#     var.subnet_id
#   ]

#   # Required to redeploy without an outage.
#   lifecycle {
#     create_before_destroy = true
#   }

#   tag {
#     key                 = "Name"
#     value               = "web"
#     propagate_at_launch = true
#   }

# }







# resource "aws_autoscaling_policy" "web_policy_up" {
#   name = "web_policy_up"
#   scaling_adjustment = 1
#   adjustment_type = "ChangeInCapacity"
#   cooldown = 300
#   autoscaling_group_name = aws_autoscaling_group.web.name
# }

# resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
#   alarm_name = "web_cpu_alarm_up"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods = "2"
#   metric_name = "CPUUtilization"
#   namespace = "AWS/EC2"
#   period = "120"
#   statistic = "Average"
#   threshold = "60"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.web.name
#   }

#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions = [ aws_autoscaling_policy.web_policy_up.arn ]
>>>>>>> 99a943c881dbaf530f8a13ded9f558d2b0308759
# }