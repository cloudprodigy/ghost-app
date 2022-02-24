/**
 * # 1. Deployment Setup
 * The Terraform code deploys following:
 * a. VPC with 2 public subnets with IGW attached and routing setup <br>
 * b. EC2 instance pre-installed with Ghost base app and it's dependencies <br>
 * c. Cron setup for backup of app and database every night <br>
 * d. Secrets Manager to generate and store DB Root user credentials <br>
 * e. Create OS user called `ghost-admin` and attaches the SSH public key provided <br>
 * ## Terraform Setup 
 * a. Download Terraform CLI v1.0 or above <br>
 * b. Generate an SSH Key pair and save the public key under `ssh_public_keys` folder <br>
 * c. Create AWS profile and update the profile name and region in `versions.tf` <br>
 * d. Run `make all` to initialize, validate, run security checks and generate Terraform documentation <br>
 * e. Run `terraform plan` to view the resources to be created  <br>
 * f. Run `terraform apply` to deploy the infra structure <br>
 * g. Copy the public IP from Terraform output..  <br>
 * h. Wait for 15-20 minutes and then access the public IP in the browser. You should see Ghost default page <br>
 */
