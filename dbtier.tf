resource "aws_db_subnet_group" "database_subnet_group" {
  subnet_ids = [aws_subnet.private_subnet["Private_Sub_DB_1C"].id, aws_subnet.private_subnet["Private_Sub_DB_1B"].id]
}
# create a RDS Database Instance
resource "aws_db_instance" "myinstance" {
  engine                 = "mysql"
  identifier             = "myrdsinstance"
  allocated_storage      = 20
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "myrdsuser"
  password               = "myrdspassword"
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [module.security-groups.security_group_id["DB_sg"]]
  skip_final_snapshot    = true
  #publicly_accessible =  true
  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.id
}
# resource "aws_security_group_rule" "opened_to_DB" {
#   type                     = "ingress"
#   from_port                = 3306
#   to_port                  = 3306
#   protocol                 = "tcp"
#   source_security_group_id = [module.security-groups.security_group_id["DB_sg"]]
#   security_group_id        = [module.security-groups.security_group_id["ALB_EC2_sg"]]
# }
# resource "aws_rds_cluster" "LabVPCDBCluster" {
#     cluster_identifier = "labvpcdbcluster"
#     engine = "aurora-mysql"
#     engine_version = "5.7.mysql_aurora.2.07.2"
#     db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
#     database_name = "Population"
#     master_username = "admin"
#     master_password = "testingrdscluster"
#     vpc_security_group_ids = [module.security-groups.security_group_id["DB_sg"]]
#     apply_immediately = true
#     skip_final_snapshot = true
# }

# output "database_endpoint" {
#     value = aws_db_instance.database_instance.address
# }