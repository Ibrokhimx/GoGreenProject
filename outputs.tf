output "my_eip" {
  value = { for k, v in aws_eip.nat : k => v.public_ip }
}

output "password" {
  value = {
    for k, v in aws_iam_user_login_profile.password : k => v.password
  }
}

output "name" {
  value = {
    for k, v in aws_iam_user.users : k => v.name
  }
}