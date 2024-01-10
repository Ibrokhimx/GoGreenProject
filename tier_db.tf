resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
resource "aws_secretsmanager_secret" "gogreen_mysql_db" {
  name                    = var.db_username
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "gogreen_mysql_db" {
  secret_id = aws_secretsmanager_secret.gogreen_mysql_db.id
  secret_string = jsonencode({
    db_name  = var.db_name
    username = var.db_username
    password = random_password.db_password.result
    host     = aws_db_instance.gogreen_mysql_db.endpoint
  })
}


resource "aws_db_subnet_group" "database_subnet_group" {
  subnet_ids = [module.private_subnets.subnet_ids["Private_Sub_DB_1C"], module.private_subnets.subnet_ids["Private_Sub_DB_1B"]]
  #subnet_ids = [aws_subnet.private_subnet["Private_Sub_DB_1C"].id, aws_subnet.private_subnet["Private_Sub_DB_1B"].id]
}
# create a RDS Database Instance
resource "aws_db_instance" "gogreen_mysql_db" {
  db_name                = var.db_name
  engine                 = var.db_engine
  identifier             = var.db_identifier
  allocated_storage      = var.db_allocated_storage
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = random_password.db_password.result
  parameter_group_name   = var.db_parameter_group_name
  vpc_security_group_ids = [module.db_security_group.security_group_id["db_sg"]]
  skip_final_snapshot    = true
  #publicly_accessible    = true
  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.id
}

resource "aws_ssm_parameter" "endpoint" {
  name  = "/example/endpoint"
  type  = "SecureString"
  value = aws_db_instance.gogreen_mysql_db.endpoint
}

resource "aws_ssm_parameter" "username" {
  name  = "/example/username"
  type  = "SecureString"
  value = var.db_username
}

resource "aws_ssm_parameter" "database" {
  name  = "/example/database"
  type  = "SecureString"
  value = var.db_name
}
resource "aws_ssm_parameter" "password" {
  name  = "/example/password"
  type  = "SecureString"
  value = random_password.db_password.result
}