variable "public_subnets" {
  type = map(object({
    name              = string,
    cidr_block        = string,
    availability_zone = string
  }))

  default = {
  }
}
variable "private_subnets" {
  type = map(object({
    name              = string,
    cidr_block        = string,
    availability_zone = string
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
variable "security-groups" {
  description = "A map of security groups with their rules"
  type = map(object({
    description = string
    ingress_rules = optional(list(object({
      description     = optional(string)
      priority        = optional(number)
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      security_groups = optional(list(string))
    })))
    egress_rules = list(object({
      description     = optional(string)
      priority        = optional(number)
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      security_groups = optional(list(string))
    }))
  }))
}
variable "key_name" {
  type    = string
  default = ""
}

variable "ssl_certificate_arn" {
  type    = string
  default = ""
}

variable "database_name" {
  type    = string
  default = ""
}
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
    tags          = map(string)
  }))
  default = {

  }
}