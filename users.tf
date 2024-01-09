resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  max_password_age               = 90
  password_reuse_prevention      = 3
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

resource "aws_secretsmanager_secret" "users" {
  name                    = "users_name_password1"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "users" {
  secret_id = aws_secretsmanager_secret.users.id
  secret_string = jsonencode({

    username1 = "${aws_iam_user.users["sysadmin1"].name}"
    password1 = "${aws_iam_user_login_profile.password["sysadmin1"].password}"
    username2 = "${aws_iam_user.users["sysadmin2"].name}"
    password2 = "${aws_iam_user_login_profile.password["sysadmin2"].password}"
    username3 = "${aws_iam_user.users["monitor1"].name}"
    password3 = "${aws_iam_user_login_profile.password["monitor1"].password}"
    username4 = "${aws_iam_user.users["monitor2"].name}"
    password4 = "${aws_iam_user_login_profile.password["monitor2"].password}"
    username5 = "${aws_iam_user.users["monitor3"].name}"
    password5 = "${aws_iam_user_login_profile.password["monitor3"].password}"
    username6 = "${aws_iam_user.users["monitor4"].name}"
    password6 = "${aws_iam_user_login_profile.password["monitor4"].password}"
    username7 = "${aws_iam_user.users["dbadmin1"].name}"
    password7 = "${aws_iam_user_login_profile.password["dbadmin1"].password}"
    username8 = "${aws_iam_user.users["dbadmin2"].name}"
    password8 = "${aws_iam_user_login_profile.password["dbadmin2"].password}"
  })
}
# resource "aws_secretsmanager_secret_version" "users" {
#   for_each  = aws_iam_user.users
#   secret_id = aws_secretsmanager_secret.users.id
#   secret_string = jsonencode({
#     "${aws_iam_user.users[each.key].name}" = "${aws_iam_user.users[each.key].name}"
#     "${aws_iam_user.users[each.key].name}" = "${aws_iam_user_login_profile.password[each.key].password}"
#   })
# }
resource "aws_iam_user" "users" {
  for_each = var.iam_user
  name     = each.value.name
  tags     = each.value["tags"]
}

resource "aws_iam_user_login_profile" "password" {
  for_each = aws_iam_user.users
  user     = aws_iam_user.users[each.key].name
}

resource "aws_iam_group" "system_admins" {
  name = "system-administrators"
}

resource "aws_iam_group" "system_monitor" {
  name = "system-monitors"
}

resource "aws_iam_group" "db_admins" {
  name = "database-administrators"
}

resource "aws_iam_group_membership" "sysadmin_membership" {
  for_each = aws_iam_user.users
  name     = "sysadmin_membership"
  users    = [aws_iam_user.users["sysadmin1"].name, aws_iam_user.users["sysadmin2"].name]
  group    = aws_iam_group.system_admins.name
}

resource "aws_iam_group_membership" "monitor_membership" {
  for_each = aws_iam_user.users
  name     = "monitor_membership"
  users = [aws_iam_user.users["monitor1"].name, aws_iam_user.users["monitor2"].name,
    aws_iam_user.users["monitor3"].name, aws_iam_user.users["monitor4"].name
  ]

  group = aws_iam_group.system_monitor.name
}

resource "aws_iam_group_membership" "dbadmin_membership" {
  for_each = aws_iam_user.users
  name     = "dbadmin_membership"
  users    = [aws_iam_user.users["dbadmin1"].name, aws_iam_user.users["dbadmin2"].name]
  group    = aws_iam_group.db_admins.name
}

data "aws_iam_policy" "sysadmin" {
  arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"

}

data "aws_iam_policy" "monitor" {
  arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"

}

data "aws_iam_policy" "db_admin" {
  arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
}
resource "aws_iam_group_policy_attachment" "sysadmin" {
  policy_arn = data.aws_iam_policy.sysadmin.arn
  group      = aws_iam_group.system_admins.name
}

resource "aws_iam_group_policy_attachment" "monitor" {
  policy_arn = data.aws_iam_policy.monitor.arn
  group      = aws_iam_group.system_monitor.name
}

resource "aws_iam_group_policy_attachment" "db_admin" {
  policy_arn = data.aws_iam_policy.db_admin.arn
  group      = aws_iam_group.db_admins.name
}

