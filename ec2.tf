module "app_server" {
  source          = "./modules/ec2"
  environment     = local.environment
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.app_server.id]
  instance_type   = "t3.medium"
  app_name        = local.app_name
  ssh_public_key  = data.local_file.ssh_public_key.content
  db_name         = "ghostdb"

}
