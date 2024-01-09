module "bastion_security_group" {
  source  = "app.terraform.io/pitt412/security-groups/aws"
  version = "4.0.0"
  vpc_id  = module.gogreen_vpc.vpc_id
  security_groups = {
    "bastion_sg" : {
      description = "Security group for bastion host"
      ingress_rules = [
        {
          description = "ingress rule for ssh"
          priority    = 201
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["${var.admin_ip}"]
        }
      ]
      egress_rules = [
        {
          description = "egress rule"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

module "web_security_group" {
  source  = "app.terraform.io/pitt412/security-groups/aws"
  version = "4.0.0"
  vpc_id  = module.gogreen_vpc.vpc_id
  security_groups = {
    "alb_web_sg" : {
      description = "Security group for web load balancer"
      ingress_rules = [
        {
          description      = "ingress rule for http"
          priority         = 220
          from_port        = 80
          to_port          = 80
          protocol         = "tcp"
          cidr_blocks      = ["0.0.0.0/0"]
          ipv6_cidr_blocks = ["::/0"]
        },
        {
          description      = "ingress rule for http"
          priority         = 204
          from_port        = 443
          to_port          = 443
          protocol         = "tcp"
          cidr_blocks      = ["0.0.0.0/0"]
          ipv6_cidr_blocks = ["::/0"]
        }
      ],
      egress_rules = [
        {
          description = "egress rule"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

module "web_security_group1" {
  source  = "app.terraform.io/pitt412/security-groups/aws"
  version = "4.0.0"
  vpc_id  = module.gogreen_vpc.vpc_id
  security_groups = {
    "web_ec2_sg" : {
      description = "Security group for web servers"
      ingress_rules = [
        {
          description     = "ingress rule for http"
          priority        = 230
          from_port       = 80
          to_port         = 80
          protocol        = "tcp"
          security_groups = [module.web_security_group.security_group_id["alb_web_sg"]]
        },
        {
          description     = "my_ssh"
          priority        = 208
          from_port       = 22
          to_port         = 22
          protocol        = "tcp"
          cidr_blocks     = ["0.0.0.0/0"]
          cidr_blocks     = [join("", [aws_instance.bastion.private_ip, "/32"])]
          security_groups = [module.bastion_security_group.security_group_id["bastion_sg"]]
        },
        {
          description = "ingress rule for http"
          priority    = 204
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ],
      egress_rules = [
        {
          description = "egress rule"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

module "app_security_group" {
  source  = "app.terraform.io/pitt412/security-groups/aws"
  version = "4.0.0"
  vpc_id  = module.gogreen_vpc.vpc_id
  security_groups = {
    "alb_app_sg" : {
      description = "Security group for app loadbalancer"
      ingress_rules = [
        {
          description     = "ingress rule for http"
          priority        = 240
          from_port       = 80
          to_port         = 80
          protocol        = "tcp"
          security_groups = [module.web_security_group1.security_group_id["web_ec2_sg"]]
        }
      ],
      egress_rules = [
        {
          description = "egress rule"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}
module "app_security_group1" {
  source  = "app.terraform.io/pitt412/security-groups/aws"
  version = "4.0.0"
  vpc_id  = module.gogreen_vpc.vpc_id
  security_groups = {
    "app_ec2_sg" : {
      description = "Security group for app servers"
      ingress_rules = [
        {
          description     = "ingress rule for http"
          priority        = 206
          from_port       = 80
          to_port         = 80
          protocol        = "tcp"
          security_groups = [module.app_security_group.security_group_id["alb_app_sg"]]
        },
        {
          description = "my_ssh"
          priority    = 202
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [join("", [aws_instance.bastion.private_ip, "/32"])]
        }
      ],
      egress_rules = [
        {
          description = "egress rule"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}
module "db_security_group" {
  source  = "app.terraform.io/pitt412/security-groups/aws"
  version = "4.0.0"
  vpc_id  = module.gogreen_vpc.vpc_id
  security_groups = {
    "db_sg" : {
      description = "Security group for Database"
      ingress_rules = [
        {
          description     = "ingress rule for DB"
          priority        = 500
          from_port       = 3306
          to_port         = 3306
          protocol        = "tcp"
          security_groups = [module.app_security_group1.security_group_id["app_ec2_sg"]]
        }
      ],
      egress_rules = [
        {
          description = "egress rule"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

# resource "aws_security_group_rule" "opened_to_alb_web" {
#   type                     = "ingress"
#   from_port                = 80
#   to_port                  = 80
#   protocol                 = "tcp"
#   source_security_group_id = "${module.web_security_group1.security_group_id["web_ec2_sg"]}"
#   security_group_id        = "${module.web_security_group.security_group_id["alb_web_sg"]}"
# }
