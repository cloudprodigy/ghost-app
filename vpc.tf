module "vpc" {
  source = "./modules/vpc"

  enable_dns_hostnames      = true
  enable_dns_support        = true
  enable_nat_gateway        = false
  enable_custom_nat_gateway = false
  create_igw                = true
  single_network_acl        = true
  one_nat_gateway_per_az    = false
  single_nat_gateway        = false
  map_public_ip_on_launch   = true

  name = "${local.project_name}-${local.app_name}-${local.environment}"

  cidr = "172.32.0.0/16"
  azs  = ["${local.region}a", "${local.region}b"]
  # private_subnets = ["172.32.8.0/23", "172.32.10.0/23"]
  public_subnets = ["172.32.0.0/23", "172.32.2.0/23"]

  tag_application = local.app_name
  tag_team        = local.team
  environment     = local.environment


}
