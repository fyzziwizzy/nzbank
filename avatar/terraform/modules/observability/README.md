# Module: observability

Central monitoring, telemetry and alerting for a Project Koru deployment, plus
the reusable diagnostics helper every other module uses.

## What it builds

| Resource | Purpose |
|---|---|
| Log Analytics workspace | Central log and metric sink with long retention. |
| Application Insights | Workspace based distributed tracing for the runtime planes. |
| Action group | Single notification target for all alert rules. |
| Metric alert | Request latency against the SLO threshold. |
| Scheduled query alerts | Availability, groundedness proxy and failed sessions. |
| Consumption budget | Cost anomaly notification for runaway model spend. |
| `diagnostics` submodule | Reusable diagnostic settings helper. |

## The diagnostics helper

`modules/diagnostics` reads the log and metric categories a target resource
actually supports and enables all of them against this workspace. Every module
that needs diagnostic settings calls it, so telemetry is complete and
consistent without hand maintained category lists.

```hcl
module "diag_example" {
  source                     = "../observability/modules/diagnostics"
  name                       = "diag-example"
  target_resource_id         = azurerm_some_resource.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}
```

## SLO alerts

| Alert | Signal | Control |
|---|---|---|
| Latency | Average `requests/duration` over threshold. | KORU-C-61 |
| Availability | Request success rate below threshold. | KORU-C-61 |
| Groundedness proxy | Ungrounded Assurance decisions per window. | KORU-C-31 |
| Failed sessions | Orchestrator sessions ending in error. | KORU-C-61 |
| Cost anomaly | Resource group budget thresholds. | KORU-C-62 |

The groundedness and failed session queries read custom tables
(`KoruAssurance_CL`, `KoruSessions_CL`) that the runtime planes emit. They are
illustrative and must be confirmed against the deployed logging schema.

## Controls

Standards: APRA CPS 230 (operational risk, monitoring and record keeping), RBNZ
BS11 (continuity evidence).

## Key outputs

`log_analytics_workspace_id`, `app_insights_id`,
`app_insights_connection_string` (sensitive), `action_group_id`.
