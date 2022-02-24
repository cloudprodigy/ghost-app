output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.vpc.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.vpc.default_security_group_id
}
output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = aws_vpc.vpc.instance_tenancy
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = aws_vpc.vpc.enable_dns_support

}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = aws_vpc.vpc.enable_dns_hostnames

}


output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}


output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private.*.arn
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private.*.cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public.*.arn
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.public.*.cidr_block
}

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat.*.id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat.*.public_ip
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this.*.id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = concat(aws_internet_gateway.this.*.id, [""])[0]
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = concat(aws_internet_gateway.this.*.arn, [""])[0]
}

output "vpc_flow_log_id" {
  description = "The ID of the Flow Log resource"
  value       = concat(aws_flow_log.this.*.id, [""])[0]
}

output "vpc_flow_log_destination_arn" {
  description = "The ARN of the destination for VPC Flow Logs"
  value       = local.flow_log_destination_arn
}

output "vpc_flow_log_destination_type" {
  description = "The type of the destination for VPC Flow Logs"
  value       = var.flow_log_destination_type
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
  value       = local.flow_log_iam_role_arn
}

output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = concat(aws_network_acl.public.*.id, [""])[0]
}

output "public_network_acl_arn" {
  description = "ARN of the public network ACL"
  value       = concat(aws_network_acl.public.*.arn, [""])[0]
}

output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = concat(aws_network_acl.private.*.id, [""])[0]
}

output "private_network_acl_arn" {
  description = "ARN of the private network ACL"
  value       = concat(aws_network_acl.private.*.arn, [""])[0]
}


output "custom_nat_subnet_ids" {
  description = "List of subnets used for custom NAT GW deployments"
  value       = { for k, v in data.aws_subnet.nat_public : k => v.id }
}

output "custom_public_subnet_ids" {
  description = "List of additional public subnets"
  value       = { for k, v in data.aws_subnet.add_public : k => v.id }
}

output "custom_private_subnet_ids" {
  description = "List of additional private subnets"
  value       = { for k, v in data.aws_subnet.add_private : k => v.id }
}

output "custom_nat_ids" {
  description = "List of custom NAT GW IDs"
  value       = { for k, v in data.aws_nat_gateway.custom : k => v.id }
}