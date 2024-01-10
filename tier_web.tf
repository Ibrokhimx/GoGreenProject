resource "aws_launch_template" "WEB_lc" {
  name_prefix   = var.prefix
  description   = "Template to launch EC2 instance and deploy the application"
  image_id      = data.aws_ami.amazon-linux2.id
  instance_type = var.instance_type
  key_name      = var.key_name
  #key_name               = aws_key_pair.WEB_tier.key_name
  vpc_security_group_ids = [module.web_security_group1.security_group_id["web_ec2_sg"]]
  iam_instance_profile {
    arn = aws_iam_instance_profile.s3_profile.arn
  }
  user_data = filebase64("script.sh")
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Gogreen-web-instance"
    }
  }

}
resource "aws_autoscaling_group" "WEB_asg" {
  vpc_zone_identifier = [module.public_subnets.subnet_ids["Public_Sub_WEB_1C"], module.public_subnets.subnet_ids["Public_Sub_WEB_1B"]]
  #vpc_zone_identifier       = [aws_subnet.public_subnet["Public_Sub_WEB_1C"].id, aws_subnet.public_subnet["Public_Sub_WEB_1B"].id]
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.WEB_tg.arn]
  launch_template {
    id      = aws_launch_template.WEB_lc.id
    version = "$Latest"
  }

}
resource "aws_autoscaling_attachment" "WEB_att" {
  autoscaling_group_name = aws_autoscaling_group.WEB_asg.id
  lb_target_group_arn    = aws_lb_target_group.WEB_tg.arn
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
  name_prefix        = "web-lb"
  idle_timeout       = 65
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [module.web_security_group.security_group_id["alb_web_sg"]]
  subnets            = [module.public_subnets.subnet_ids["Public_Sub_WEB_1C"], module.public_subnets.subnet_ids["Public_Sub_WEB_1B"]]
  #subnets            = [aws_subnet.public_subnet["Public_Sub_WEB_1C"].id, aws_subnet.public_subnet["Public_Sub_WEB_1B"].id]
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
resource "aws_lb_target_group" "WEB_tg" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.gogreen_vpc.vpc_id
  target_type = "instance"
  health_check {
    path                = "/"
    interval            = 200
    timeout             = 60
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200" # has to be HTTP 200 or fails
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 120
  }
}


output "WEB_alb" {
  value = aws_lb.WEB_alb.dns_name
}




