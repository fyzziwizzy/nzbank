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

variable "jurisdiction" {
  type        = string
  description = "Data sovereignty jurisdiction. AU or NZ."
}

variable "instance" {
  type        = string
  description = "Instance number, zero padded."
  default     = "001"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy security resources into."
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to every resource."
}

variable "tenant_id" {
  type        = string
  description = "Entra ID tenant id for the Key Vault."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet id for private endpoints."
}

variable "private_dns_zone_ids" {
  type        = map(string)
  description = "Map of private DNS zone ids keyed by service. Must include vault."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics workspace for diagnostic settings."
}

variable "key_vault_sku" {
  type        = string
  description = "Key Vault SKU. premium is HSM backed and required for regulated key material."
  default     = "premium"

  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "key_vault_sku must be standard or premium."
  }
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Key Vault soft delete retention window in days."
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Whether purge protection is enabled. Must be true in production to protect key material."
  default     = true
}

variable "key_vault_admin_object_ids" {
  type        = list(string)
  description = "Object ids granted Key Vault Administrator, including the deployment identity so it can create keys and secrets."
  default     = []
}

variable "cmk_key_type" {
  type        = string
  description = "Customer managed key type. RSA-HSM requires the premium SKU."
  default     = "RSA-HSM"

  validation {
    condition     = contains(["RSA", "RSA-HSM"], var.cmk_key_type)
    error_message = "cmk_key_type must be RSA or RSA-HSM."
  }
}

variable "cmk_key_size" {
  type        = number
  description = "Customer managed key size in bits."
  default     = 3072
}

variable "cmk_expiry_days" {
  type        = number
  description = "Customer managed key lifetime in days before rotation and expiry."
  default     = 365
}

variable "enable_defender" {
  type        = bool
  description = "Whether to enable Microsoft Defender for Cloud plans. Subscription scoped."
  default     = true
}

variable "defender_plans" {
  type        = list(string)
  description = "Defender for Cloud plans to enable at the Standard tier."
  default = [
    "KeyVaults",
    "StorageAccounts",
    "Containers",
    "CosmosDbs",
    "Arm",
    "AppServices",
    "OpenSourceRelationalDatabases",
    "Api"
  ]
}

variable "bootstrap_secrets" {
  type        = map(string)
  description = "Platform wiring secrets to seed into Key Vault, for example the App Insights connection string. Values come from other module outputs, never hard coded."
  default     = {}
  sensitive   = true
}
