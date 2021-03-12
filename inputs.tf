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
  description = "VPC ID in which the VPC endpoint will be created."
  type = string
}

variable "vpc_endpoint_service_name" {
  description = "AWS Registry name of the VPC endpoint service which this VPC endpoint will be associated with. Must be specified in the form of an FQDN."
  type = string
}

variable "auto_accept" {
  description = "Whether the association between the VPC endpoint service and this VPC endpoint are auto-accepted. Determined by the VPC endpoint service. In production deployments, this value is usually false."
  type = bool
  default = false
}

variable "subnet_ids" {
  description = "Subnet IDs that will be associated with this VPC endpoint - this ultimately creates EIF devices in those subnets. Only subnets that are colocated in availability zones which the VPC endpoint service are hosted in will be accepted."
  type = list(string)
}

variable "security_group_ids" {
  description = "List of security groups that restrict access to this VPC endpoint. Overrides 'security_group_ingress_rules' and 'security_group_cidr_blocks'."
  type = list(string)
  default = ["_"]
}

variable "security_group_ingress_rules" {
  description = "List of ingress rules that apply to the built-in security group. Overridden by 'security_group_ids'."
  type = list(tuple([ number, number, string ]))
  default = [[0, 0, "-1"]]
}

variable "security_group_cidr_blocks" {
  description = "List of IPv4 CIDR blocks that apply to the built-in security group ingress rules. Overridden by 'security_group_ids'."
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "policy" {
  description = "IAM policy for restricting access to this VPC endpoint. Defaults to full access."
  type = string
  default = ""
}

variable "alternate_private_dns_domain_name" {
  description = "Alternate private DNS domain name for communicating over this VPC endpoint. May be used to construct an initiating FQDN that is an alias of the VPC endpoint DNS entry list."
  type = string
  default = ""
}

variable "alternate_private_dns_hostname" {
  description = "Hostname to associate with a private DNS record pointing to this VPC endpoint. May be used to construct an initiating FQDN that is an alias of the VPC endpoint DNS entry list."
  type = string
  default = ""
}
