
variable "environment" {
  type        = string
  description = "Environment name"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}
variable "project_name" {
  type        = string
  description = "Project name"
}

variable "codestar_connection_arn" {
  description = "AWS CodeStart Connection ID"
  type        = string
}

variable "github_repo_owner" {
  description = "Owner of repository"
  type        = string
}


variable "github_repo_name" {
  description = "Name of backend repository"
  type        = string
}

variable "github_repo_branch" {
  description = "Name of backend repository branch"
  type        = string
}

variable "s3_artifact_store" {
  description = "Bucket where artifacts will be stored"
  type        = string
}


variable "cicd_role" {
  description = "IAM Role to attach with CI/CD pipeline"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}


variable "app_name" {
  description = "Application name"
  type        = string
}

locals {
  common_tags = {
    environment = var.environment
    project     = var.project_name
    application = var.app_name
  }
}


