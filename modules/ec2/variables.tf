variable "subnet_id" {
  description = "The VPC where the instance will be created."
  type        = string
}

variable "environment" {
  type        = string
  description = "The environment where the resources will be created."
}

variable "instance_type" {
  description = "The type of the EC2 instance."
  type        = string
  default     = "t2.micro"
}


variable "security_groups" {
  description = "A list of security group names or IDs to associate with"
  type        = list(string)
  default     = []
}

variable "app_name" {
  description = "Application name"
  type        = string

}

variable "db_username" {
  description = "Application DB user"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}
variable "ssh_public_key" {
  description = "SSH public key to be added to EC2 instance"
  type        = string
}

locals {
  common_tags = {
    environment = var.environment
  }
}
