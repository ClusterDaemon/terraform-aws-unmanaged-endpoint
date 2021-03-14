# terraform-aws-unmanaged-endpoint

Terraform resource module that creates a VPC interface endpoint with an optional alternative private FQDN and built-in security group.

The alternate private FQDN is accomplished by creating a private zone (or using an existing one), and establishing an alias record to this VPC endpoint. This is useful for communicating with services across a VPC endpoint via HTTPS when a given domain is protected by a certificate, or when a webserverx expects HTTP(s) headers to be of a particular initiating DNS name..

This module captures the usage patterns required to specify a working endpoint within a single invocation.

- [terraform-aws-unmanaged-endpoint](#terraform-aws-unmanaged-endpoint)
  - [Features](#features)
  - [Usage](#usage)
  - [Dependencies](#dependencies)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Resource Types](#resource-types)
  - [Contributing](#contributing)
  - [Change Log](#change-log)
  - [Authors](#authors)


## Features:

This module aims to enable inter-VPC communication using a VPC endpoint to an already established VPC endpoint service.

 - VPC interface endpoint creation.
 - VPC endpoint service attribute discovery.
 - Arbitrary private DNS FQDN creation, pointing to the created VPC endpoint.
 - Default security group open to private traffic. Default may be overridden.
 - Conditional resource creation.


## Usage:

See the [examples directory](examples) for complete example usage.


## Dependencies

| Binary | Version |
| terraform | >= 0.13.0 |

| Provider | Version |
| --- | --- |
| aws | >= 2.41 |

| Resource |
| --- |
| aws\_vpc |
| aws\_subnet |


## Inputs:

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| vpc\_id | AWS ID of the VPC in which resources will be created and associated with. | string | nil | yes |
| name | Name which will be applied to all created resources, where applicable. | string | "VPC Endpoint" | no |
| vpc\_endpoint\_service\_name | AWS Registry name of the VPC endpoint service which this VPC endpoint will be associated with. Must be specified in the form of an FQDN. | string | nil | yes |
| subnet\_ids | AWS Registry name of the VPC endpoint service which this VPC endpoint will be associated with. Must be specified in the form of an FQDN. | list(string) | nil | yes |
| security\_group\_ids | List of security groups that restrict access to this VPC endpoint. Overrides `security_group_ingress_rules` and `security_group_cidr_blocks`. | list(string) | nil | yes |
| security\_group\_ingress\_rules | List of ingress rules that apply to the built-in security group. Overridden by `security_group_ids`. | list(tuple([ number, number, string ])) | [ [ 0, 0, "-1", ], ] | no |
| security\_group\_cidr\_blocks | List of IPv4 CIDR blocks that apply to the built-in security group ingress rules. Overridden by `security_group_ids` | list(string) | \[ "0.0.0.0/0", \] | no |
| policy | IAM policy for restricting access to this VPC endpoint. Defaults to full access. Expects an ARN. | string | nil | no |
| alternate\_private\_dns | Attributes which set a domain and alias record that points to a VPC endpoint. Useful when a VPC endpoint service requires traffic to be initated using a specific URL in order to route requests properly. | object({`name` = string, `domain` = string, zone\_id = ""}) | {`name` = "", `domain` = "", zone\_id = ""}) | no |
| tags | Map of AWS tags which apply to the VPC endpoint. | map(string) | nil | no |
| create\_resources | Controls whether any resource in-module is created. | bool | true | no |


## Outputs:

| Name | Description | Type |
| --- | --- | --- |
| endpoint\_id | AWS Id of the VPC interface endpoint. | string |
| endpoint\_network\_interface\_ids | List of network interface (EIF) IDs for the VPC endpoint. | list(string) |
| endpoint\_dns\_entry | List of DNS attributes that describe the VPC endpoint interface(s) - accessible only within the VPC this VPC endpoint resides. Includes `dns_name` and `hosted_zone_id`. | list(object({ `dns_name` = string, `hosted_zone_id` = string, })) |
| endpoint\_alternate\_dns\_entry | "Private DNS attributes associated with a VPC endpoint interface. This can be useful when dealing with VPC endpoint services which expect initiators to use a specific URL to route requests internally. | object({`dns_name` = string, `hosted_zone_id` = string})

## Resource Types

 * aws\_vpc\_endpoint
 * aws\_route53\_zone
 * aws\_route53\_record
 * aws\_security\_group


## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/ClusterDaemon/terraform-aws-unmanaged-endpoint/issues/new) section.

Full contributing [guidelines are covered here](https://github.com/ClusterDaemon/terraform-aws-unmanaged-endpoint/blob/master/CONTRIBUTING.md).


## Change Log

The [changelog](https://github.com/ClusterDaemon/terraform-aws-unmanaged-endpoint/tree/master/CHANGELOG.md) captures all important release notes.


## Authors

Created and maintained by [David Hay](https://github.com/ClusterDaemon) - david.hay@nebulate.tech
