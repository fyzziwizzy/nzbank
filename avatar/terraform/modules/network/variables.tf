# Network module inputs.

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

  validation {
    condition     = contains(["dev", "test", "prd"], var.environment)
    error_message = "environment must be one of dev, test or prd."
  }
}

variable "region_code" {
  type        = string
  description = "Region short code. aue Australia East, aus Australia Southeast, nzn New Zealand North."

  validation {
    condition     = contains(["aue", "aus", "nzn"], var.region_code)
    error_message = "region_code must be one of aue, aus or nzn."
  }
}

variable "location" {
  type        = string
  description = "Azure region long name, for example australiaeast or newzealandnorth."
}

variable "jurisdiction" {
  type        = string
  description = "Data sovereignty jurisdiction. AU or NZ."

  validation {
    condition     = contains(["AU", "NZ"], var.jurisdiction)
    error_message = "jurisdiction must be AU or NZ."
  }
}

# Sovereignty guard rail. New Zealand workloads must not run in Australian
# regions and vice versa. This enforces the hard no cross Tasman rule from the
# programme canon in code, not just in policy. Control KORU-C-21.
variable "allowed_locations" {
  type        = list(string)
  description = "Regions permitted for this jurisdiction. Used to validate location."
}

variable "instance" {
  type        = string
  description = "Instance number, zero padded, for example 001."
  default     = "001"
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to every resource."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the virtual network, for example [\"10.30.0.0/16\"]."
}

variable "subnet_prefixes" {
  type = object({
    edge        = string
    runtime     = string
    privatelink = string
    apim        = string
    firewall    = string
    bastion     = string
  })
  description = "CIDR prefixes for each subnet. Must sit inside vnet_address_space and not overlap."
}

variable "firewall_sku_tier" {
  type        = string
  description = "Azure Firewall SKU tier. Premium adds TLS inspection and IDPS."
  default     = "Premium"

  validation {
    condition     = contains(["Standard", "Premium"], var.firewall_sku_tier)
    error_message = "firewall_sku_tier must be Standard or Premium."
  }
}

variable "deploy_bastion" {
  type        = bool
  description = "Whether to deploy an Azure Bastion host for break glass administrative access."
  default     = true
}

variable "allowed_egress_fqdns" {
  type        = list(string)
  description = "Explicit FQDN allow list for outbound traffic through the firewall."
  default = [
    "*.openai.azure.com",
    "*.cognitiveservices.azure.com",
    "*.search.windows.net",
    "*.blob.core.windows.net",
    "*.vault.azure.net",
    "login.microsoftonline.com",
    "*.azurecr.io",
    "mcr.microsoft.com",
    "*.data.mcr.microsoft.com",
    "management.azure.com",
    "*.monitor.azure.com",
    "*.applicationinsights.azure.com"
  ]
}

variable "dns_servers" {
  type        = list(string)
  description = "Custom DNS servers for the virtual network. Empty uses Azure provided DNS."
  default     = []
}
