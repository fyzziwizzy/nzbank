terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

locals {
  name_prefix = "${var.org}-${var.programme}"
  suffix      = "${var.environment}-${var.region_code}-${var.instance}"
}

# ---------------------------------------------------------------------------
# Log Analytics workspace. Central sink for logs, metrics and the interaction
# telemetry that underpins operational evidence. Long retention supports the
# record keeping obligations in APRA CPS 230 and RBNZ BS11. Control KORU-C-60.
# ---------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "this" {
  name                       = "log-${local.name_prefix}-${local.suffix}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku                        = var.log_analytics_sku
  retention_in_days          = var.log_retention_days
  daily_quota_gb             = var.daily_quota_gb
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  tags                       = var.tags
}

# ---------------------------------------------------------------------------
# Application Insights, workspace based. Distributed tracing for the runtime
# planes and the source of the latency and availability SLI signals.
# ---------------------------------------------------------------------------
resource "azurerm_application_insights" "this" {
  name                  = "appi-${local.name_prefix}-${local.suffix}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_id          = azurerm_log_analytics_workspace.this.id
  application_type      = "web"
  sampling_percentage   = var.app_insights_sampling_percentage
  retention_in_days     = var.log_retention_days
  internet_query_enabled = true
  tags                  = var.tags
}

# ---------------------------------------------------------------------------
# Action group. Single notification target referenced by every alert rule.
# ---------------------------------------------------------------------------
resource "azurerm_monitor_action_group" "platform" {
  name                = "ag-${local.name_prefix}-platform-${local.suffix}"
  resource_group_name = var.resource_group_name
  short_name          = "koruops"
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.alert_email_receivers
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email
      use_common_alert_schema = true
    }
  }
}

# ---------------------------------------------------------------------------
# SLO alert rules. These map directly to the service level objectives in the
# operations documentation. Control KORU-C-61 service level monitoring.
# ---------------------------------------------------------------------------

# Latency. Average server side request duration over the SLO threshold.
resource "azurerm_monitor_metric_alert" "latency" {
  name                = "alert-${local.name_prefix}-latency-${local.suffix}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.this.id]
  description         = "Server side request latency has exceeded the SLO threshold."
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "requests/duration"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.latency_threshold_ms
  }

  action {
    action_group_id = azurerm_monitor_action_group.platform.id
  }
}

# Availability. Failed request rate as an inverse availability signal.
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "availability" {
  name                 = "alert-${local.name_prefix}-availability-${local.suffix}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  severity             = 1
  evaluation_frequency = "PT5M"
  window_duration      = "PT15M"
  scopes               = [azurerm_application_insights.this.id]
  description          = "Availability has dropped below the SLO threshold based on request success rate."
  tags                 = var.tags

  criteria {
    query                   = <<-KQL
      let threshold = ${var.availability_threshold_percent};
      AppRequests
      | summarize total = count(), failed = countif(Success == false)
      | extend availability = iff(total == 0, 100.0, 100.0 * (total - failed) / total)
      | where availability < threshold
      | project availability
    KQL
    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.platform.id]
  }
}

# Groundedness proxy. Counts assistant turns flagged as ungrounded by the
# Assurance Plane. A grounded response only posture is a conduct control, so a
# spike here is treated as a safety signal. Control KORU-C-31.
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "groundedness" {
  name                 = "alert-${local.name_prefix}-groundedness-${local.suffix}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  severity             = 1
  evaluation_frequency = "PT15M"
  window_duration      = "PT1H"
  scopes               = [azurerm_log_analytics_workspace.this.id]
  description          = "Ungrounded response rate has exceeded tolerance. Potential conduct risk."
  tags                 = var.tags

  criteria {
    query                   = <<-KQL
      KoruAssurance_CL
      | where Decision_s == "ungrounded"
      | summarize ungrounded = count() by bin(TimeGenerated, 15m)
      | where ungrounded > 5
    KQL
    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.platform.id]
  }
}

# Failed sessions. Counts orchestrator sessions that ended in an error state.
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "failed_sessions" {
  name                 = "alert-${local.name_prefix}-failedsessions-${local.suffix}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  severity             = 2
  evaluation_frequency = "PT5M"
  window_duration      = "PT30M"
  scopes               = [azurerm_log_analytics_workspace.this.id]
  description          = "Session failure rate has exceeded tolerance."
  tags                 = var.tags

  criteria {
    query                   = <<-KQL
      KoruSessions_CL
      | where Status_s == "failed"
      | summarize failed = count() by bin(TimeGenerated, 5m)
      | where failed > 10
    KQL
    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.platform.id]
  }
}

# ---------------------------------------------------------------------------
# Cost anomaly. A resource group budget with staged notifications. Runaway
# model spend is both a financial and an operational risk signal.
# Control KORU-C-62 cost control.
# ---------------------------------------------------------------------------
resource "azurerm_consumption_budget_resource_group" "this" {
  name              = "budget-${local.name_prefix}-${local.suffix}"
  resource_group_id = data.azurerm_resource_group.this.id

  amount     = var.monthly_budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00'Z'", timestamp())
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Actual"
    contact_emails = var.budget_contact_emails
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Forecasted"
    contact_emails = var.budget_contact_emails
  }

  lifecycle {
    # The start date is derived from apply time. Ignore it so the budget is not
    # recreated on every run.
    ignore_changes = [time_period]
  }
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}
