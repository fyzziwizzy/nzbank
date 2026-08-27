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
  description = "Resource group to deploy AI services into."
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
  description = "Map of private DNS zone ids. Must include openai and cognitiveservices."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics workspace for diagnostic settings."
}

variable "cmk_key_versionless_id" {
  type        = string
  description = "Versionless customer managed key id used to encrypt the accounts."
}

variable "cmk_identity_id" {
  type        = string
  description = "Resource id of the user assigned identity that holds key access."
}

variable "cmk_identity_client_id" {
  type        = string
  description = "Client id of the user assigned identity that holds key access."
}

variable "openai_sku" {
  type        = string
  description = "SKU for the Azure OpenAI account."
  default     = "S0"
}

variable "speech_sku" {
  type        = string
  description = "SKU for the Speech service account."
  default     = "S0"
}

variable "content_safety_sku" {
  type        = string
  description = "SKU for the Content Safety account."
  default     = "S0"
}

# Model deployments. Regional Standard SKUs are used deliberately rather than
# Global so that inference stays inside the jurisdiction. Cross Tasman routing
# of prompts or completions is not permitted. Control KORU-C-21 and KORU-C-30.
variable "model_deployments" {
  type = map(object({
    deployment_name = string
    model_name      = string
    model_version   = string
    sku_name        = string
    capacity        = number
  }))
  description = "Map of logical role to model deployment configuration."
  default = {
    conversational = {
      deployment_name = "koru-fast"
      model_name      = "gpt-4o-mini"
      model_version   = "2024-07-18"
      sku_name        = "Standard"
      capacity        = 50
    }
    reasoning = {
      deployment_name = "koru-reason"
      model_name      = "gpt-4o"
      model_version   = "2024-08-06"
      sku_name        = "Standard"
      capacity        = 30
    }
    classifier = {
      deployment_name = "koru-classify"
      model_name      = "gpt-4o-mini"
      model_version   = "2024-07-18"
      sku_name        = "Standard"
      capacity        = 20
    }
    embedding = {
      deployment_name = "koru-embed"
      model_name      = "text-embedding-3-large"
      model_version   = "1"
      sku_name        = "Standard"
      capacity        = 60
    }
  }
}
