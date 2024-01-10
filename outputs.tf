output "my_eip" {
  value = { for k, v in aws_eip.nat : k => v.public_ip }
}
output "rt53dns" {
  value = aws_route53_record.alias_route53_record.records

}
output "database_endpoint" {
  value = aws_db_instance.gogreen_mysql_db.endpoint
}

# output "password" {
#   value = {
#     for k, v in aws_iam_user_login_profile.password : k => v.password
#   }
# }

# output "name" {
#   value = {
#     for k, v in aws_iam_user.users : k => v.name
#   }
# }
