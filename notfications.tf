# resource "aws_sns_topic" "my_topic" {
#   name = "MySNSTopic"
# }

# resource "aws_sns_topic_subscription" "email_subscription" {
#   topic_arn = aws_sns_topic.my_topic.arn
#   protocol  = "email"
#   endpoint  = "ibrokhimx@gmail.com"
# }

# resource "aws_cloudwatch_metric_alarm" "http_400_errors_alarm" {
#   alarm_name          = "Http400ErrorsAlarm"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 1
#   metric_name         = "HTTPCode_ELB_4XX_Count"
#   namespace           = "AWS/ELB"
#   period              = 60
#   statistic           = "Sum"
#   threshold           = 100
#   actions_enabled     = true

#   dimensions = {
#     load_balancer_name = aws_lb.WEB_alb.name
#   }

#   alarm_actions = ["arn:aws:sns:us-west-1:822553477440:MySNSTopic"]
#   ok_actions    = ["arn:aws:sns:us-west-1:822553477440:MySNSTopic"]
# }