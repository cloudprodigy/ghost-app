resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  vpc = true

  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        var.name,
        element(var.azs, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.nat_eip_tags,
    local.common_tags
  )
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway && var.enable_custom_nat_gateway == false ? local.nat_gateway_count : 0

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id = element(
    aws_subnet.public.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )

  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        var.name,
        element(var.azs, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.nat_gateway_tags,
    local.common_tags
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_eip" "nat_custom" {
  for_each = aws_subnet.nat_public
  vpc      = true

  tags = merge(
    var.nat_eip_tags,
    local.common_tags
  )
}

resource "aws_nat_gateway" "custom" {
  for_each = aws_subnet.nat_public

  allocation_id = aws_eip.nat_custom[each.key].id
  subnet_id     = each.value.id

  tags = merge(
    {
      "Name" = format(
        "NATGW-%s", each.value.availability_zone
      )
    },
    var.nat_gateway_tags,
    local.common_tags
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway_default_route && var.enable_nat_gateway ? local.nat_gateway_count : 0

  route_table_id         = element(var.private_route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index)

  timeouts {
    create = "5m"
  }
}