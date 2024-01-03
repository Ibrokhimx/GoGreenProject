# security-groups = {
#   "ALB_WEB_sg" : {
#     description = "Security group for web servers"
#     ingress_rules = [
#       {
#         description = "ingress rule for http"
#         priority    = 200
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       },
#       {
#         description = "ingress rule for http"
#         priority    = 204
#         from_port   = 443
#         to_port     = 443
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#     egress_rules = [
#       {
#         description = "egress rule"
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   },
#   "WEB_EC2_sg" : {
#     description = "Security group for web servers"
#     ingress_rules = [
#       {
#         description = "ingress rule for http"
#         priority    = 200
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       },
#       {
#         description = "my_ssh"
#         priority    = 202
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       },
#       {
#         description = "ingress rule for http"
#         priority    = 204
#         from_port   = 443
#         to_port     = 443
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#     egress_rules = [
#       {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   },
#   "ALB_APP_sg" : {
#     description = "Security group for web servers"
#     ingress_rules = [
#       {
#         description = "ingress rule for http"
#         priority    = 200
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#         #security_groups = [var.security-groups.security_groups["ALB_WEB_sg"]]
#       }
#     ]
#     egress_rules = [
#       {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   },
#   "APP_EC2_sg" : {
#     description = "Security group for web servers"
#     ingress_rules = [
#       {
#         description = "ingress rule for http"
#         priority    = 200
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#         #security_groups = [module.security-groups.security_group_id["ALB_APP_sg"]]
#       },
#       {
#         description = "my_ssh"
#         priority    = 202
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#     egress_rules = [
#       {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   },
#   "DB_sg" : {
#     description = "Security group for Database"
#     ingress_rules = [
#       {
#         description = "ingress rule for DB"
#         priority    = 500
#         from_port   = 3306
#         to_port     = 3306
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#         #security_groups = [module.security-groups["ALB_WEB_sg"].id]
#       }
#     ]
#     egress_rules = [
#       {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   }
# }


public_subnets = {
  Public_Sub_WEB_1C = {
    name              = "Public_Sub_WEB_1C",
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-west-1c"
  },
  Public_Sub_WEB_1B = {
    name              = "Public_Sub_WEB_1B",
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-west-1b"
  },
}
private_subnets = {
  Private_Sub_APP_1C = {
    name              = "Private_Sub_APP_1C",
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-west-1c"
  },
  Private_Sub_APP_1B = {
    name              = "Private_Sub_APP_1B",
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-west-1b"
  },
  Private_Sub_DB_1C = {
    name              = "Private_Sub_DB_1C",
    cidr_block        = "10.0.5.0/24"
    availability_zone = "us-west-1c"
  },
  Private_Sub_DB_1B = {
    name              = "Private_Sub_DB_1B",
    cidr_block        = "10.0.6.0/24"
    availability_zone = "us-west-1b"
  }
}


nat-rta = {
  APP-1C = {
    route_table_id = "Public_Sub_WEB_1C",
    subnet_id      = "Private_Sub_APP_1C"
  },
  DB-1C = {
    route_table_id = "Public_Sub_WEB_1C",
    subnet_id      = "Private_Sub_DB_1C"
  },
  APP-1B = {
    route_table_id = "Public_Sub_WEB_1B",
    subnet_id      = "Private_Sub_APP_1B"
  },
  DB-1B = {
    route_table_id = "Public_Sub_WEB_1B",
    subnet_id      = "Private_Sub_DB_1B"

  }

}
iam_user = {
  sysadmin1 = {
    name = "sysadmin1"
    tags = { creator = "sysadmin1"
  } },
  sysadmin2 = {
    name = "sysadmin2"
    tags = { creator = "sysadmin2"
  } }
  monitor1 = {
    name = "monitor1"
    tags = { creator = "monitor1"
  } }
  monitor2 = {
    name = "monitor2"
    tags = { creator = "monitor2"
  } }
  monitor3 = {
    name = "monitor3"
    tags = { creator = "monitor3"
  } }
  monitor4 = {
    name = "monitor4"
    tags = { creator = "monitor4"
  } }
  dbadmin1 = {
    name = "dbadmin1"
    tags = { creator = "dbadmin1"
  } }
  dbadmin2 = {
    name = "dbadmin2"
    tags = { creator = "dbadmin2"
  } }
}

# nat-rta = {
#   APP-1C = {
#     subnet_id      =  "",
#     route_table_id = ""

#   },
#   DB-1C = {
#     subnet_id      =  "",
#     route_table_id = ""

#   },
#   APP-1B = {
#     subnet_id      =  "",
#     route_table_id = ""
#   },
#   DB-1B = {
#     subnet_id      =  "",
#     route_table_id = ""

#   },

# }