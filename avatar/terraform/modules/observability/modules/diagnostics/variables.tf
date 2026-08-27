# Reusable diagnostic settings helper.
# Enables every supported log category and metric for a target resource and
# routes them to the central Log Analytics workspace. Consistent, complete
# telemetry underpins monitoring control KORU-C-60 and the operational risk
# evidence required by APRA CPS 230.

variable "name" {
  type        = string
  description = "Name of the diagnostic setting, for example diag-fb-koru-kv-prd-nzn-001."
}

variable "target_resource_id" {
  type        = string
  description = "Resource id whose logs and metrics are collected."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Destination Log Analytics workspace resource id."
}

variable "log_analytics_destination_type" {
  type        = string
  description = "Destination table layout. Dedicated uses resource specific tables where supported."
  default     = "Dedicated"

  validation {
    condition     = contains(["Dedicated", "AzureDiagnostics"], var.log_analytics_destination_type)
    error_message = "log_analytics_destination_type must be Dedicated or AzureDiagnostics."
  }
}
