resource "aws_launch_configuration" "WEB_lc" {
  name_prefix                 = var.prefix
  image_id                    = data.aws_ami.amazon-linux2.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.WEB_tier.key_name
  security_groups             = [module.web_security_group1.security_group_id["web_ec2_sg"]]
  associate_public_ip_address = true
  #iam_instance_profile = aws_iam_instance_profile.s3_profile.id
  user_data = filebase64("${path.module}/application.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "WEB_tg" {
  #name_prefix = var.prefix
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_autoscaling_group" "WEB_asg" {
  name_prefix          = var.prefix
  launch_configuration = aws_launch_configuration.WEB_lc.name
  min_size             = 2
  max_size             = 4
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_subnet.public_subnet["Public_Sub_WEB_1C"].id, aws_subnet.public_subnet["Public_Sub_WEB_1B"].id]
  target_group_arns    = [aws_lb_target_group.WEB_tg.arn]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "WEB_asg_policy" {
  name                   = "WEB_asg_policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.WEB_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

resource "aws_lb" "WEB_alb" {
  #name_prefix        = var.prefix
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.web_security_group.security_group_id["alb_web_sg"]]
  subnets            = [aws_subnet.public_subnet["Public_Sub_WEB_1C"].id, aws_subnet.public_subnet["Public_Sub_WEB_1B"].id]
}

resource "aws_lb_listener" "WEB_alb_listener_1" {
  load_balancer_arn = aws_lb.WEB_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WEB_tg.arn
  }

}
  # default_action {
  #   type = "redirect"

  #   redirect {
  #     port        = "443"
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }
# resource "aws_acm_certificate" "example" {
#   # ...
# }


# resource "aws_lb_listener_certificate" "example" {
#   listener_arn    = aws_lb_listener.WEB_alb_listener_1.arn
#   certificate_arn = aws_acm_certificate.example.arn
# }
# resource "aws_lb_listener" "WEB_alb_listener_2" {
#   load_balancer_arn = aws_lb.WEB_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   #certificate_arn   = aws_lb_listener_certificate.example
#   #certificate_arn   = var.ssl_certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.WEB_tg.arn
#   }
# }


output "WEB_alb" {
  value = aws_lb.WEB_alb.dns_name
}




# resource "aws_autoscaling_group" "WEB_tier" {
#   name                      = "Launch-Temp-ASG-Pres-Tier"
#   max_size                  = 6
#   min_size                  = 2
#   health_check_grace_period = 300
#   health_check_type         = "EC2"
#   desired_capacity          = 2
#   vpc_zone_identifier       = aws_subnet.public_subnets.*.id

#   launch_template {
#     id      = aws_launch_template.presentation_tier.id
#     version = "$Latest"
#   }

#   lifecycle {
#     ignore_changes = [load_balancers, target_group_arns]
#   }

#   tag {
#     key                 = "Name"
#     value               = "presentation_app"
#     propagate_at_launch = true
#   }
# }
# resource "aws_autoscaling_attachment" "WEB_tier" {
#   autoscaling_group_name = aws_autoscaling_group.WEB_tier.id
#   lb_target_group_arn    = aws_lb_target_group.WEB_tier.arn
# }
# resource "aws_lb" "WEB_end" {
#   name               = "WEB-end-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_presentation_tier.id]
#   subnets            = aws_subnet.public_subnets.*.id

#   enable_deletion_protection = false
# }

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.front_end.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.front_end.arn
#   }
# }

# resource "aws_lb_target_group" "front_end" {
#   name     = "front-end-lb-tg"
#   port     = 3000
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id
# }

