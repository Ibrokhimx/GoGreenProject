resource "aws_instance" "bastion" {
  ami             = data.aws_ami.amazon-linux2.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.bastion.key_name
  subnet_id       = aws_subnet.public_subnet["Public_Sub_WEB_1C"].id
  security_groups = [module.bastion_security_group.security_group_id["bastion_sg"]]
  tags = {
    Name = "bastion host"
  }
}
resource "aws_key_pair" "bastion" {
  key_name   = "bastion"
  public_key = file("~/.ssh/cloud_2024.pem.pub")
  lifecycle {
    ignore_changes = [public_key]
  }
}