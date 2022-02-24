variable "environment" {
  description = "The environment"
}

variable "bucket_name" {
  description = "Bucket name to be created"
}

variable "account_id" {
  description = "AWS Account ID"
}

variable "service" {

}

locals {
  common_tags = {
    environment = var.environment
  }
}
