variable "vpc_cidr_block" {
  type    = string
  default = ""
}
# variable "true" {
#   type = bool
#   default = false
# }
variable "public_subnets" {
  type = map(object({
    name                    = string,
    cidr_block              = string,
    availability_zone       = string,
    map_public_ip_on_launch = bool
  }))

  default = {
  }
}
variable "private_subnets" {
  type = map(object({
    name                    = string,
    cidr_block              = string,
    availability_zone       = string,
    map_public_ip_on_launch = bool
  }))

  default = {
  }
}
variable "prefix" {
  type    = string
  default = "GoGreen-project"

}
variable "nat-rta" {
  type = map(object({
    route_table_id = string,
    subnet_id      = string
  }))
  default = {
  }
}
variable "key_name" {
  type    = string
  default = ""

}
variable "instance_type" {
  type    = string
  default = ""

}
variable "bastion_name" {
  type    = string
  default = "bastion-host"

}
variable "db_name" {
  type    = string
  default = ""

}
variable "db_username" {
  type    = string
  default = ""

}
variable "db_engine" {
  type    = string
  default = ""

}
variable "db_identifier" {
  type    = string
  default = ""

}
variable "db_engine_version" {
  type    = string
  default = ""

}

variable "db_instance_class" {
  type    = string
  default = ""

}

variable "db_parameter_group_name" {
  type    = string
  default = ""

}

variable "db_allocated_storage" {
  type    = string
  default = ""

}


# variable "security-groups" {
#   description = "A map of security groups with their rules"
#   type = map(object({
#     description = string
#     ingress_rules = optional(list(object({
#       description     = optional(string)
#       priority        = optional(number)
#       from_port       = number
#       to_port         = number
#       protocol        = string
#       cidr_blocks     = optional(list(string))
#       security_groups = optional(list(string))
#     })))
#     egress_rules = list(object({
#       description     = optional(string)
#       priority        = optional(number)
#       from_port       = number
#       to_port         = number
#       protocol        = string
#       cidr_blocks     = list(string)
#       security_groups = optional(list(string))
#     }))
#   }))
# }


# variable "ssl_certificate_arn" {
#   type    = string
#   default = ""
# }

# variable "iam_user" {
#   type = map(object({
#     name = string,
#     tags =map(string)

#   }))
#   default = {
#   }
# }
variable "iam_user" {
  type = map(object({
    name = string,
    tags = map(string)
  }))
  default = {

  }
}
variable "dbusername" {
  description = "The username for the DB master user"
  type        = string
  default     = "admin"
}
variable "dbpassword" {
  description = "The password for the DB master user"
  type        = string
  default     = "password"
}
variable "admin_ip" {
  type    = string
  default = "0.0.0.0/0"
}