resource "aws_launch_configuration" "APP_lc" {
  name_prefix          = var.prefix
  image_id             = data.aws_ami.amazon-linux2.id
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.APP_tier.key_name
  security_groups      = [module.app_security_group1.security_group_id["app_ec2_sg"]]
 #iam_instance_profile = aws_iam_instance_profile.s3_profile.id
  user_data            = filebase64("${path.module}/application.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "APP_tg" {
  #name_prefix = var.prefix
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_autoscaling_group" "APP_asg" {
  name_prefix          = var.prefix
  launch_configuration = aws_launch_configuration.APP_lc.name
  min_size             = 2
  max_size             = 4
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_subnet.private_subnet["Private_Sub_APP_1C"].id, aws_subnet.private_subnet["Private_Sub_APP_1B"].id]
  target_group_arns    = [aws_lb_target_group.APP_tg.arn]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "APP_asg_policy" {
  name                   = "APP_asg_policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.APP_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

resource "aws_lb" "APP_alb" {
  #name_prefix        = var.prefix
  internal           = true
  load_balancer_type = "application"
  security_groups    = [module.app_security_group.security_group_id["alb_app_sg"]]
  subnets            = [aws_subnet.private_subnet["Private_Sub_APP_1C"].id, aws_subnet.private_subnet["Private_Sub_APP_1B"].id]
}

resource "aws_lb_listener" "APP_alb_listener_1" {
  load_balancer_arn = aws_lb.APP_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.APP_tg.arn
  }
}


output "APP_alb" {
  value = aws_lb.APP_alb.dns_name
}

# resource "aws_autoscaling_group" "APP_tier" {
#   name                      = "Launch-Temp-ASG-App-Tier"
#   max_size                  = 4
#   min_size                  = 2
#   health_check_grace_period = 300
#   health_check_type         = "EC2"
#   desired_capacity          = 2
#   vpc_zone_identifier       = aws_subnet.private_subnets.*.id

#   launch_template {
#     id      = aws_launch_template.application_tier.id
#     version = "$Latest"
#   }

#   lifecycle {
#     ignore_changes = [load_balancers, target_group_arns]
#   }

#   tag {
#     key                 = "Name"
#     value               = "APP_app"
#     propagate_at_launch = true
#   }
# }
# resource "aws_autoscaling_attachment" "APP_tier" {
#   autoscaling_group_name = aws_autoscaling_group.APP_tier.id
#   lb_target_group_arn    = aws_lb_target_group.front_end.arn
# }

