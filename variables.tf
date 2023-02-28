varaiable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "instance_type" {
  type = string
}

variable "asg_max_size" {
  type = number

  validation {
    condition     = var.asg_max_size > 0
    error_message = "Max size must be greater than zero"
  }
}

variable "vpc_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "vpc_subnet_ids" {
  type = list(string)
}
