################
# Public subnet
################
resource "aws_subnet" "public" {
  count = length(var.public_subnets) > 0 && (var.one_nat_gateway_per_az == false || length(var.public_subnets) >= length(var.azs)) ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      Name = "${lower(var.name)}-${element(var.azs, count.index)}-public-sn"
    },
    var.public_subnet_tags,
    local.common_tags
  )

  lifecycle {
    ignore_changes = [
      tags["Name"]
    ]
  }
}


#################
# Private subnet
#################
resource "aws_subnet" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id               = aws_vpc.vpc.id
  cidr_block           = var.private_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      Name = "${lower(var.name)}-${element(var.azs, count.index)}-private-sn"
    },
    var.private_subnet_tags,
    local.common_tags
  )

  lifecycle {
    ignore_changes = [
      tags["Name"]
    ]
  }
}