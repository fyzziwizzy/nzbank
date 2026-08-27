variable "org" {
  type        = string
  description = "Organisation short code used in resource names."
  default     = "fb"
}

variable "programme" {
  type        = string
  description = "Programme short code used in resource names."
  default     = "koru"
}

variable "environment" {
  type        = string
  description = "Environment code. One of dev, test or prd."
}

variable "region_code" {
  type        = string
  description = "Region short code. aue, aus or nzn."
}

variable "location" {
  type        = string
  description = "Azure region long name."
}

variable "instance" {
  type        = string
  description = "Instance number, zero padded."
  default     = "001"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy knowledge resources into."
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to every resource."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet id for private endpoints."
}

variable "private_dns_zone_ids" {
  type        = map(string)
  description = "Map of private DNS zone ids. Must include search and blob."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics workspace for diagnostic settings."
}

variable "cmk_key_versionless_id" {
  type        = string
  description = "Versionless customer managed key id used to encrypt the corpus storage account."
}

variable "cmk_identity_id" {
  type        = string
  description = "Resource id of the user assigned identity that holds key access."
}

variable "search_sku" {
  type        = string
  description = "Azure AI Search SKU."
  default     = "standard"

  validation {
    condition     = contains(["basic", "standard", "standard2", "standard3"], var.search_sku)
    error_message = "search_sku must be one of basic, standard, standard2 or standard3."
  }
}

variable "search_replica_count" {
  type        = number
  description = "Number of search replicas. Three or more is required for query SLA and zone redundancy."
  default     = 3
}

variable "search_partition_count" {
  type        = number
  description = "Number of search partitions."
  default     = 1
}

variable "search_semantic_sku" {
  type        = string
  description = "Semantic search tier. free or standard, or null to disable."
  default     = "standard"
}
