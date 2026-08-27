# Reusable private endpoint primitive.
# Every PaaS service in Project Koru is reached over a private endpoint so that
# no data plane is exposed to the public internet. This satisfies the private
# connectivity control (KORU-C-24) and the network isolation expectations of
# APRA CPS 234 and RBNZ BS11.

variable "name" {
  type        = string
  description = "Name of the private endpoint, for example pe-fb-koru-kv-prd-nzn-001."
}

variable "location" {
  type        = string
  description = "Azure region for the private endpoint, for example australiaeast."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group that holds the private endpoint."
}

variable "subnet_id" {
  type        = string
  description = "Resource id of the private link subnet the endpoint NIC is placed into."
}

variable "private_connection_resource_id" {
  type        = string
  description = "Resource id of the target PaaS resource the private endpoint connects to."
}

variable "subresource_names" {
  type        = list(string)
  description = "Target sub resources, for example [\"vault\"], [\"blob\"], [\"account\"] or [\"sqlServer\"]."
}

variable "private_dns_zone_ids" {
  type        = list(string)
  description = "Private DNS zone ids to register the endpoint A records into. Empty list skips the DNS zone group."
  default     = []
}

variable "is_manual_connection" {
  type        = bool
  description = "Whether the private endpoint requires manual approval on the target resource."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the private endpoint."
  default     = {}
}
