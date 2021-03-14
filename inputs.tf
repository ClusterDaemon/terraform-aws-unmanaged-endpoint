variable "create_resources" {
  description = "Whether or not to create resources in this module."
  type = bool
  default = true
}

variable "name" {
  description = "Name which will be applied to all created resources, where applicable."
  type = string
  default = "VPC Endpoint"
}

variable "tags" {
  description = "Map of AWS tags which apply to the VPC endpoint."
  type = map(string)
  default = {}
}

variable "vpc_id" {
  description = "VPC in which the VPC endpoint will be created."
  type = string
}

variable "vpc_endpoint_service_name" {
  description = "AWS Endpoint Registry name of the VPC endpoint service which this VPC endpoint will be associated with. Must be specified in the form of an FQDN."
  type = string
}

variable "auto_accept" {
  description = "Whether the association between the VPC endpoint service and this VPC endpoint are auto-accepted. Determined by the VPC endpoint service. In production deployments, this value is usually false."
  type = bool
  default = false
}

variable "subnet_ids" {
  description = "Subnets in which EIFs will be created. Only subnets that are colocated in availability zones which the VPC endpoint service are hosted in will work. All others will yield an error."
  type = list(string)
}

variable "security_group_ids" {
  description = "List of security groups that restrict access to this VPC endpoint. Overrides 'security_group_ingress_rules' and 'security_group_cidr_blocks'."
  type = list(string)
  default = ["_"]
}

variable "security_group_ingress_rules" {
  description = "List of ingress rules that apply to the built-in security group. Overridden by 'security_group_ids'. The default of allowing all ports is still fairly secure, as this rule is applied only to private traffic. However, it is still prudent to restrict this if required ports and protocols are known ahead of time."
  type = list(tuple([ number, number, string ]))
  default = [[0, 0, "-1"]]
}

variable "security_group_cidr_blocks" {
  description = "List of IPv4 CIDR blocks that apply to the built-in security group ingress rules. Overridden by 'security_group_ids'. The default of 0.0.0.0/0 is still secure, as this still only allows private network nodes to ingress this endpoint."
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "policy" {
  description = "IAM policy for restricting access to this VPC endpoint. Defaults to full access."
  type = string
  default = ""
}

variable "alternate_private_dns" {
  description = "Attributes which set a domain and alias record that points to a VPC endpoint. Useful when a VPC endpoint service requires traffic to be initated using a specific URL in order to route requests properly. Expected attributes are name and domain, or name and zone_id. Use zone_id for a private zone which already exists. Use domain to make a zone exist."
  type = object({name = string, domain = string, zone_id = string})
  default = {name = "", domain = "", zone_id = ""}
}
