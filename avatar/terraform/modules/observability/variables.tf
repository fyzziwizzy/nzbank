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
  description = "Resource group to deploy monitoring resources into."
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to every resource."
}

variable "log_retention_days" {
  type        = number
  description = "Log Analytics retention in days. Regulated record keeping needs a long horizon."
  default     = 730

  validation {
    condition     = var.log_retention_days >= 30 && var.log_retention_days <= 730
    error_message = "log_retention_days must be between 30 and 730."
  }
}

variable "log_analytics_sku" {
  type        = string
  description = "Log Analytics workspace SKU."
  default     = "PerGB2018"
}

variable "daily_quota_gb" {
  type        = number
  description = "Daily ingestion cap in GB. Negative means unlimited."
  default     = -1
}

variable "app_insights_sampling_percentage" {
  type        = number
  description = "Application Insights sampling percentage."
  default     = 100
}

variable "alert_email_receivers" {
  type = list(object({
    name  = string
    email = string
  }))
  description = "Email receivers for the platform action group."
  default     = []
}

variable "monthly_budget_amount" {
  type        = number
  description = "Monthly cost budget for the resource group, used for cost anomaly alerting."
  default     = 50000
}

variable "budget_contact_emails" {
  type        = list(string)
  description = "Email addresses notified when budget thresholds are crossed."
  default     = []
}

variable "latency_threshold_ms" {
  type        = number
  description = "Server side request latency SLO threshold in milliseconds."
  default     = 1500
}

variable "availability_threshold_percent" {
  type        = number
  description = "Availability SLO threshold as a percentage."
  default     = 99
}
