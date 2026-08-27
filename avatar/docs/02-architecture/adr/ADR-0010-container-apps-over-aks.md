# ADR-0010: Azure Container Apps rather than Azure Kubernetes Service

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 15 July 2026 |
| **Decision makers** | Head of Platform Engineering, Chief Architect, Head of Infrastructure |
| **Contested** | Yes. The infrastructure team's existing standard is AKS. |
| **Reversibility** | **Moderate.** Containers are portable. One to two quarters. |
| **Related risks** | KORU-R-07 latency |

---

## Context

Koru's runtime consists of four long-lived services: the Orchestrator, the Assurance Plane, the Reasoning Plane and the Knowledge gateway. They are containerised, stateless apart from session affinity in the Orchestrator, and have spiky, unpredictable load driven by conversational traffic.

Fern Bank's established container platform standard is Azure Kubernetes Service. The platform team operates several AKS clusters, has mature practice around them, and reasonably asked why Koru should be different.

## Decision

**Koru runs on Azure Container Apps with dedicated workload profiles, VNet integrated, internal ingress only, zone redundant.**

| Aspect | Configuration |
|---|---|
| Environment | Workload profile environment, not Consumption only |
| Profile | Dedicated D-series for the Reasoning and Assurance planes, Consumption for lower-tier services |
| Networking | Injected into `snet-runtime`, internal load balancer, no public ingress |
| Ingress | Internal only. Public traffic arrives via Front Door and Private Link |
| Identity | User assigned managed identity per app, no secrets in the container |
| Scaling | HTTP concurrency and custom metric rules, minimum replicas above zero for latency-sensitive apps |
| Zone redundancy | Enabled |

Critically, **the minimum replica count is never zero** for the Orchestrator, Assurance and Reasoning apps. Scale to zero is the headline Container Apps feature and it is exactly wrong for a service with a 1.2 second p95 latency target. A cold start would blow the entire budget.

## Consequences

### Positive

- **Materially less platform toil.** No cluster upgrades, no node pool management, no CNI decisions, no ingress controller to patch. For a team of the size funded in the business case, this is the difference between shipping and operating.
- **Faster path to Phase 0.** Roughly six weeks saved against standing up a compliant AKS cluster with the required policy, mesh and observability configuration.
- **The security posture we need is available and simpler to evidence.** VNet integration, internal ingress, managed identity, Key Vault references, private registry pull. All present, all configurable in Terraform, all inspectable.
- **Revision-based deployment** gives clean blue/green and instant rollback, which matters enormously for a system where a bad prompt or model configuration change must be reversible in seconds. This directly supports the incident response kill switch design.
- **Built-in Dapr and KEDA scaling** without operating them ourselves.

### Negative

- **Less control.** No custom admission controllers, no service mesh of our choosing, no node-level tuning, no privileged workloads.
- **Divergence from the Fern Bank platform standard.** Two container platforms to operate, and the AKS-experienced team must learn a second model. This was the principal objection and it is legitimate.
- **Some enterprise tooling assumes Kubernetes.** Certain security agents and policy tools have weaker Container Apps support. Assessed and acceptable for this workload, but it constrained our tooling choices.
- **Scaling behaviour is less tunable** than AKS with a bespoke HPA configuration. For a latency-sensitive workload we compensate with a generous minimum replica floor, which costs money.
- **Ceiling risk.** If Koru grows well beyond the modelled concurrency, we may hit Container Apps limits and need to move.

### Neutral

- Cost is broadly comparable at the modelled scale. Container Apps is cheaper at low and spiky load, AKS is cheaper at sustained high load. The crossover is above Phase 1 volumes.

## Alternatives considered

| Option | Assessment |
|---|---|
| **Azure Kubernetes Service** | The standard, and a genuinely defensible choice. Rejected for Phase 1 because the additional control it offers is not required by this workload, while the operational burden is real and the delivery timeline is not generous. We would revisit if Koru's scale or workload shape changed materially. |
| **Azure App Service** | Rejected. Adequate for the simpler services, but weaker for the long-lived WebRTC signalling connections in the Orchestrator and less flexible for scaling on custom metrics. |
| **Azure Functions** | Rejected. Conversational sessions are long-lived and stateful within a turn. A serverless function model fits poorly, and cold start is fatal to the latency budget. |
| **Azure Container Instances** | Rejected. No native scaling, no revision model, no ingress management. |

## Conditions on this decision

Because this diverges from the Fern Bank standard, we accept three conditions:

1. **The containers must remain platform-neutral.** No Container Apps-specific runtime dependency in application code. Configuration is injected by environment variable and Key Vault reference, both of which work identically on AKS. Verified by a CI check.
2. **An AKS deployment path is maintained in Terraform as a documented, tested alternative.** **Planned** for Phase 0 exit. It does not need to be running, it needs to be provable.
3. **The decision is reviewed at Phase 2**, when concurrency will be better understood, and again if peak concurrent sessions exceed 60 percent of the modelled Container Apps ceiling.

## Reversibility

Moderate, and deliberately kept that way by condition 1. The containers themselves are standard OCI images with no platform coupling. Moving to AKS is an infrastructure and pipeline exercise, estimated at one to two quarters including the compliance re-evidencing, with no application rewrite.

---

## Related documents

- [Solution architecture](../solution-architecture.md) (FB-KORU-200)
- [Cloud services catalogue](../cloud-services-catalogue.md) (FB-KORU-201)
- [Network and connectivity](../network-and-connectivity.md) (FB-KORU-205)
- [Runbook](../../05-operations/runbook.md) (FB-KORU-504)
- `terraform/modules/avatar-runtime`
