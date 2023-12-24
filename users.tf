# resource "aws_iam_user" "sysadmin1" {
#   name = "sysadmin1"

#   tags = {
#     creator = "sysadmin1"
#   }
# }
# resource "aws_iam_access_key" "sysadmin1_access_key" {
#   user = aws_iam_user.sysadmin1.name
# }

# output "access_key_id" {
#   value = aws_iam_access_key.sysadmin1_access_key.id
#   sensitive = true
# }

# output "secret_access_key" {
#   value = aws_iam_access_key.sysadmin1_access_key.secret
#   sensitive = true
# }

# locals {
#   sysadmin1_keys_csv = "access_key,secret_key\n${aws_iam_access_key.sysadmin1_access_key.id},${aws_iam_access_key.achintha_access_key.secret}"
# }

# resource "local_file" "sysadmin1_keys" {
#   content  = local.sysadmin1_keys_csv
#   filename = "asysadmin1-keys.csv"
# }
# resource "aws_iam_group" "system_admins" {
#   name = "system-administrators"
# }

# resource "aws_iam_group_membership" "sysadmin1_membership" {
#   name = aws_iam_user.sysadmin1.name
#   users = [aws_iam_user.sysadmin1.name]
#   group = aws_iam_group.system_admins.name
# }
# #rds full
# data "aws_iam_policy" "rds_full_access" {
#   arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
# }

# #ec2 custome

# data "aws_iam_policy_document" "ec2_instance_actions" {
#   statement {
#     actions = [
#       "ec2:StartInstances",
#       "ec2:StopInstances",
#     ]

#     resources = [
#       "arn:aws:ec2:*:*:instance/*",
#     ]
#   }
# }

# resource "aws_iam_policy" "ec2_instance_actions" {
#   name        = "ec2_instance_actions"
#   policy      = data.aws_iam_policy_document.ec2_instance_actions.json
# }

# resource "aws_iam_group_policy_attachment" "terraform-developers_rds_full_access" {
#   policy_arn = data.aws_iam_policy.rds_full_access.arn
#   group      = aws_iam_group.terraform-developers.name
# }

# resource "aws_iam_group_policy_attachment" "developers_ec2_instance_actions" {
#   policy_arn = aws_iam_policy.ec2_instance_actions.arn
#   group      = aws_iam_group.terraform-developers.name
# }