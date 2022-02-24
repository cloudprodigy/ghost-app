
##############
# Additional Public Subnets
##############
resource "aws_subnet" "add_public" {
  for_each          = var.additional_public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["availability_zone"]

  tags = merge(
    {
      Name = each.value["subnet_name"]
    },
    var.public_subnet_tags,
    local.common_tags
  )
}


##############
# Additional Private Subnets
##############
resource "aws_subnet" "add_private" {
  for_each          = var.additional_private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["availability_zone"]

  tags = merge(
    {
      Name = each.value["subnet_name"]
    },
    var.private_subnet_tags,
    local.common_tags
  )
}

##############
# Additional Public Subnets for NAT Gateways
##############
resource "aws_subnet" "nat_public" {
  for_each          = var.custom_nat_gateway_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["availability_zone"]

  tags = merge(
    {
      Name = each.value["subnet_name"]
    },
    var.public_subnet_tags,
    local.common_tags
  )
}
