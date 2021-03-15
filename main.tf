terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      version = ">= 2.41"
    }
  }
}

data "aws_vpc_endpoint_service" "this" {
  service_name = var.vpc_endpoint_service_name
}

resource "aws_vpc_endpoint" "this" {
  count = var.create_resources == true ? 1 : 0

  vpc_id = var.vpc_id
  service_name = var.vpc_endpoint_service_name
  vpc_endpoint_type = "Interface"
  subnet_ids = var.subnet_ids
  security_group_ids = tolist(var.security_group_ids) == tolist(["_"]) ? aws_security_group.this[*].id : var.security_group_ids
  policy = var.policy != "" ? var.policy : null
  private_dns_enabled = false
  # Specifying an incorrect auto_accept value will cause service name matching failure.
  auto_accept = var.auto_accept

  tags = merge({ Name = var.name }, var.tags)
}

resource "aws_route53_zone" "this" {
  count = var.create_resources && var.alternate_private_dns.domain != "" && var.alternate_private_dns.zone_id == "" ? 1 : 0

  name = var.alternate_private_dns.domain

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge({ Name = var.name }, var.tags)

}

resource "aws_route53_record" "this" {
  count = var.create_resources == true && var.alternate_private_dns.name != "" ? 1 : 0

  name = var.alternate_private_dns.name
  zone_id = var.alternate_private_dns.zone_id == "" ? join("", aws_route53_zone.this[*].zone_id) : var.alternate_private_dns.zone_id
  type = "A"
  
  alias {
    name = join("", aws_vpc_endpoint.this[*].dns_entry[0].dns_name)
    zone_id = join("", aws_vpc_endpoint.this[*].dns_entry[0].hosted_zone_id)
    evaluate_target_health = false
  }

}

resource "aws_security_group" "this" {
  count = var.create_resources == true ? 1 : 0

  name = var.name
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_ingress_rules

    content {
      from_port = ingress.value[0]
      to_port = ingress.value[1]
      protocol = ingress.value[2]
      cidr_blocks =  var.security_group_cidr_blocks
    }

  }

  tags = merge(
    { Name = var.name },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }

}
