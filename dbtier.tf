resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "$%&"
}
resource "aws_secretsmanager_secret" "gogreen_mysql_db" {
  name                    = "gogreen_db_instance1"
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "gogreen_mysql_db" {
  secret_id = aws_secretsmanager_secret.gogreen_mysql_db.id
  secret_string = jsonencode({
    db_name  = "mydb"
    username = "dbadmin"
    password = random_password.db_password.result
    host     = aws_db_instance.gogreen_mysql_db.endpoint
  })
}


resource "aws_db_subnet_group" "database_subnet_group" {
  subnet_ids = [aws_subnet.private_subnet["Private_Sub_DB_1C"].id, aws_subnet.private_subnet["Private_Sub_DB_1B"].id]
}
# create a RDS Database Instance
resource "aws_db_instance" "gogreen_mysql_db" {
  db_name                = "mydb"
  engine                 = "mysql"
  identifier             = "myrdsinstance"
  allocated_storage      = 20
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = var.dbusername
  password               = random_password.db_password.result
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [module.db_security_group.security_group_id["db_sg"]]
  skip_final_snapshot    = true
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.id
}

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

