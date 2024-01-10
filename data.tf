data "aws_ami" "amazon-linux2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}
# data "aws_ami" "amazon-linux2" {
#   owners      = ["amazon"]
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-kernel-*"]
#   }
# }
