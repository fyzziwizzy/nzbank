# Read the categories the target resource actually supports so the setting is
# valid for any resource type without hand maintaining category lists.
data "azurerm_monitor_diagnostic_categories" "this" {
  resource_id = var.target_resource_id
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                           = var.name
  target_resource_id             = var.target_resource_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type

  # Enable all available log category groups reported by the platform.
  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.this.log_category_types
    content {
      category = enabled_log.value
    }
  }

  # Enable all available metric categories.
  dynamic "enabled_metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.this.metrics
    content {
      category = enabled_metric.value
    }
  }

  lifecycle {
    # Azure occasionally reorders categories. Avoid perpetual diffs.
    ignore_changes = [log_analytics_destination_type]
  }
}
