# 1. Deployment Setup
The Terraform code deploys following:
a. VPC with 2 public subnets with IGW attached and routing setup
b. EC2 instance pre-installed with Ghost base app and it's dependencies
c. Cron setup for backup of app and database every night
d. Secrets Manager to generate and store DB Root user credentials
e. Create OS user called `ghost-admin` and attaches the SSH public key provided
## Terraform Setup
a. Download Terraform CLI v1.0 or above
b. Generate an SSH Key pair and save the public key under `ssh_public_keys` folder
c. Create AWS profile and update the profile name and region in `versions.tf`
d. Run `make all` to initialize, validate, run security checks and generate Terraform documentation
e. Run `terraform plan` to view the resources to be created
f. Run `terraform apply` to deploy the infra structure
g. Copy the public IP from Terraform output..
h. Wait for 15-20 minutes and then access the public IP in the browser. You should see Ghost default page

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.74.3 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_server"></a> [app\_server](#module\_app\_server) | ./modules/ec2 | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.app_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [local_file.ssh_public_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_public_ip"></a> [ec2\_public\_ip](#output\_ec2\_public\_ip) | App server public ip address |
