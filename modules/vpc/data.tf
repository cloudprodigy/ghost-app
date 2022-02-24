data "aws_subnet" "add_public" {
  for_each = var.additional_public_subnets
  filter {
    name   = "tag:Name"
    values = [each.value["subnet_name"]]
  }
  depends_on = [aws_subnet.add_public]
}

data "aws_subnet" "add_private" {
  for_each = var.additional_private_subnets
  filter {
    name   = "tag:Name"
    values = [each.value["subnet_name"]]
  }
  depends_on = [aws_subnet.add_private]
}

data "aws_subnet" "nat_public" {
  for_each = var.custom_nat_gateway_subnets
  filter {
    name   = "tag:Name"
    values = [each.value["subnet_name"]]
  }
  depends_on = [aws_subnet.nat_public]
}

data "aws_nat_gateway" "custom" {
  for_each  = var.custom_nat_gateway_subnets
  subnet_id = data.aws_subnet.nat_public[each.key].id
}

data "aws_subnet_ids" "default" {
  vpc_id = aws_vpc.vpc.id

  depends_on = [aws_subnet.public, aws_subnet.private]
}