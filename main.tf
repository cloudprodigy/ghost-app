/**
 * #Deployment Setup
 * The Terraform code deploys following:   <br>
 * a. VPC with 2 public subnets with IGW attached and routing setup <br>
 * b. EC2 instance pre-installed with Ghost base app and it's dependencies <br>
 * c. Cron setup for backup of app and database every night <br>
 * d. Secrets Manager to generate and store DB Root user credentials <br>
 * e. Create OS user called `ghost-admin` and attaches the provided SSH public key <br>
 * f. Deploy CodePipeline with CodeDeploy to deploy app on the EC2 instance <br>
 * ## Terraform Setup 
 * a. Download Terraform CLI v1.0 or above <br>
 * b. Generate an SSH Key pair and save the public key under `ssh_public_keys` folder <br>
 * c. Create AWS profile and update the profile name and region in `versions.tf` <br>
 * d. Run `make all` to initialize, validate, run security checks and generate Terraform documentation <br>
 * e. Run `terraform plan` to view the resources to be created  <br>
 * f. Run `terraform apply` to deploy the infra structure <br>
 * g. Copy the public IP from Terraform output..  <br>
 * h. Wait for 15-20 minutes and then access the public IP in the browser. You should see Ghost default page <br>
 * ## Enhancements
 * Following is the breakdown of possible enhancements and moderinzation of the infra setup  <br>
 * ### Removing single point of failure
 * a. RDS instead of local MySQL database  <br>
 * b. Containerization of the app and deploy on EKS/ECS for better scalability  <br>
 * ### Public endpoint protection
 * a. Setup ALB in front of the application  <br>
 * b. Use WAF and integrate it with ALB  <br>
 * ### Security & Encryption
 * a. Deploy RDS and EKS/ECS in private subnets with dedicated KMS keys for encrption at rest  <br>
 * b. If using EKS, create secrets to store sensitive credentials  <br>
 * c. Setup ACM to enable encryption in transit  <br>
 * ### Backup and Notification (for EC2 based deployments)
 * a. Create SSM document to run scripts on EC2 instance to take backups  <br>
 * b. Create Lambda function to call SSM documents and sends notification on failure or success using SNS  <br>
 * c. Create CloudWatch scheduled event to call Lambda function periodically  <br>
 * <i> Above setup takes out the crontab and smtp setup on EC2 instance and make it more serverless</i>  <br>
 * ### OS User and SSH key setup (for EC2 based deployment) 
 * a. Pull SSH public key for the user from github.com  <br>
 * b. Create OS user same as github user  <br>
 * c. Use Lambda and SSM document to pull SSH public key from github.com and add the OS user   <br>
 */
