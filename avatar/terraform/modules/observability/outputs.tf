output "log_analytics_workspace_id" {
  description = "Resource id of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.name
}

output "log_analytics_customer_id" {
  description = "Workspace customer id (workspace GUID)."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "app_insights_id" {
  description = "Resource id of the Application Insights component."
  value       = azurerm_application_insights.this.id
}

output "app_insights_app_id" {
  description = "Application Insights application id."
  value       = azurerm_application_insights.this.app_id
}

output "app_insights_connection_string" {
  description = "Application Insights connection string. Store in Key Vault, not in app config."
  value       = azurerm_application_insights.this.connection_string
  sensitive   = true
}

output "app_insights_instrumentation_key" {
  description = "Application Insights instrumentation key."
  value       = azurerm_application_insights.this.instrumentation_key
  sensitive   = true
}

output "action_group_id" {
  description = "Resource id of the platform action group."
  value       = azurerm_monitor_action_group.platform.id
}
