output "ec2_public_ip" {
  value       = module.app_server.ec2_public_ip
  description = "App server public ip address"
}
