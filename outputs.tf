output "endpoint_id" {
  description = "Unique ID of VPC endpoint."
  value = join("", aws_vpc_endpoint.this[*].id)
}

output "network_interface_ids" {
  description = "List of network interfaces (EIF) for the VPC endpoint."
  value = flatten(aws_vpc_endpoint.this[*].network_interface_ids)
}

output "endpoint_dns_entry" {
  description = "List of DNS attributes associated with a VPC endpoint interface. These are set by AWS, and can be used to reliably resolve this endpoint. Includes 'dns_name' and 'hosted_zone_id'."
  value = flatten(aws_vpc_endpoint.this[*].dns_entry)
}

output "endpoint_alternate_dns_entry" {
  description = "DNS attributes associated with a VPC endpoint interface. These are set by this module, are private to the VPC in which this endpoint resides, and may be used to resolve this endpoint via an arbitrary DNS name. This can be useful when dealing with VPC endpoint services which expect initiators to use a specific URL to route requests internally. Includes dns_name and hosted_zone_id."
  value = {
    dns_name = join("", aws_route53_record.this[*].fqdn)
    hosted_zone_id = join("" , aws_route53_record.this[*].zone_id)
  }
}
