variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = map(object({
    name              = string
    cidr_block        = string
    availability_zone = string
    map_public_ip_on_launch = bool
  }))
  default = {}
}

variable "prefix" {
  type = string
}
# variable "map_public_ip_on_launch" {
#   type = bool
  
# }