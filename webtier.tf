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
