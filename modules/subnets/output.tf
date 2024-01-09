output "subnet_ids" {
  value = { for k, v in aws_subnet.subnet : k => v.id }
}
# output subnet_id {
#     value = aws_subnet.subnet.id
# }