resource "aws_launch_template" "APP_lc" {
  name_prefix   = var.prefix
  description   = "Template to launch EC2 instance and deploy the application"
  image_id      = data.aws_ami.amazon-linux2.id
  instance_type = "t2.micro"
  key_name      = "GoGreen"
  #key_name               = aws_key_pair.WEB_tier.key_name
  vpc_security_group_ids = [module.app_security_group1.security_group_id["app_ec2_sg"]]
  iam_instance_profile {
    arn = aws_iam_instance_profile.s3_profile.arn
  }
  user_data = filebase64("application.sh")
}

resource "aws_lb_target_group" "APP_tg" {
  name        = "APPalb"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
  health_check {
    path                = "/"
    interval            = 200
    timeout             = 60
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200" # has to be HTTP 200 or fails
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 120
  }
}
resource "aws_autoscaling_group" "APP_asg" {
  name_prefix = var.prefix
  launch_template {
    id      = aws_launch_template.APP_lc.id
    version = "$Latest"
  }
  min_size            = 2
  max_size            = 4
  health_check_type   = "ELB"
  vpc_zone_identifier = [aws_subnet.private_subnet["Private_Sub_APP_1C"].id, aws_subnet.private_subnet["Private_Sub_APP_1B"].id]
  target_group_arns   = [aws_lb_target_group.APP_tg.arn]

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_attachment" "APP_att" {
  autoscaling_group_name = aws_autoscaling_group.APP_asg.id
  lb_target_group_arn    = aws_lb_target_group.APP_tg.arn
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
  name_prefix        = "APP-"
  idle_timeout       = 65
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

