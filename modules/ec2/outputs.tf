output "ec2_public_ip" {
  value       = aws_eip.default.public_ip
  description = "public ip address"
}
