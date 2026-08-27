# ADR-0003: Two sovereign deployments, no cross-Tasman data movement

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 20 June 2026 |
| **Decision makers** | Chief Architect, CISO, General Counsel, Head of Compliance (both jurisdictions) |
| **Contested** | No. Unanimous, though the cost was uncomfortable. |
| **Reversibility** | **One way door.** Once customers are told where their data lives, moving it is a trust and regulatory event, not an engineering change. |
| **Related risks** | KORU-R-03 vendor concentration (partially amplified by this decision) |

---

## Context

Fern Bank operates two regulated entities: Fern Bank Limited in New Zealand, supervised by the RBNZ, and Fern Bank Australia Limited in Australia, supervised by APRA.

A conversational avatar generates an unusually intimate data trail. Not just what a customer did, but what they asked, how they phrased it, what they were worried about, and in what tone. Voice audio, transcripts, derived inferences and vector embeddings of customer questions are all personal information, and some of it is more revealing than the transaction data it sits alongside.

The engineering-efficient design is one trans-Tasman platform: one control plane, one retrieval corpus, one evaluation pipeline, one on-call roster, failover across the Tasman for resilience.

We considered that design carefully and rejected it.

## Decision

**Koru runs as two fully separate sovereign deployments. New Zealand customer data stays in New Zealand. Australian customer data stays in Australia. There is no cross-Tasman replication of customer content, transcripts, embeddings, prompts or model telemetry, for any reason, including disaster recovery.**

Resilience within each jurisdiction is delivered by availability zones and, in Australia, by a second Australian region. It is never delivered by failing over across the Tasman.

| Deployment | Primary | Secondary | Failover boundary |
|---|---|---|---|
| `prod-nz` | New Zealand North | New Zealand North availability zones | Within New Zealand only |
| `prod-au` | Australia East | Australia Southeast | Within Australia only |
| `dev`, `test` | Australia East | None | Synthetic data only, never production customer data |

### What may cross the Tasman

To be precise, because "nothing crosses" is rarely literally true and an ARB deserves the exact line:

| Data | Crosses? | Note |
|---|---|---|
| Voice audio, transcripts, prompts, completions | **No** | Never leaves jurisdiction |
| Vector embeddings of customer utterances | **No** | Embeddings are treated as personal information |
| Customer identifiers, account data | **No** | |
| Session and conversation state | **No** | |
| Ledger records | **No** | Two separate ledgers |
| Aggregated, non-re-identifiable service metrics (latency percentiles, error rates, availability) | **Yes** | Required for one global on-call view. No customer content, no identifiers, k-anonymity floor applied |
| Approved product corpus source documents | **Yes, one way** | Authored centrally, published into each jurisdiction. Not customer data |
| Prompt templates, policy configuration, model configuration, infrastructure code | **Yes** | Not customer data |
| Evaluation datasets | **Synthetic only** | Real customer conversations are never used as evaluation data outside jurisdiction, and by default not at all. See ADR-0008 |

The aggregated metrics exception is deliberately narrow and is enforced at the telemetry pipeline, which strips content and identifiers before export. This is control KORU-C-24 and it is tested.

## Consequences

### Positive

- **A clean answer to the question a customer will actually ask.** "Where is my conversation stored?" has a one sentence answer in each country.
- **IPP 12 (NZ) and APP 8 (AU) cross-border disclosure obligations are largely avoided rather than managed.** Avoiding an obligation is more durable than satisfying it with contractual assurances.
- **BS11 is materially easier to defend.** The New Zealand entity's ability to continue operating on failure of an offshore party is not theoretical when there is no offshore dependency for customer data in the first place.
- **A regulatory or legal event in one jurisdiction does not contaminate the other.** A New Zealand data access order cannot reach Australian customer content through this platform, and the reverse.
- **Blast radius halves.** A compromise of one deployment does not expose the other.

### Negative

- **Roughly 1.7 times the platform run cost** of a single shared deployment. Duplicated AI capacity, duplicated search, duplicated data platform, duplicated observability.
- **Two of everything to operate.** Two deployment pipelines, two sets of alerts, two capacity models, two evaluation runs, two sets of drift baselines.
- **Smaller evaluation samples per jurisdiction**, which slows statistical detection of rare failure modes. We compensate by sharing synthetic and de-identified aggregate evaluation findings, not data.
- **No cross-Tasman disaster recovery.** A total loss of the New Zealand North region takes New Zealand Koru offline until the region recovers. We accept this precisely because Koru is not on the basic banking path. This trade-off would be unacceptable for Fern Core and we would not make it there.
- **Slower feature rollout.** Every change ships twice.

### Neutral

- Model and prompt configuration is shared, so conversational behaviour stays consistent across both markets without sharing any customer data.

## Alternatives considered

| Option | Assessment |
|---|---|
| **Single trans-Tasman platform in Australia East** | Rejected. Would place New Zealand customer conversation data offshore, triggering IPP 12 and creating a significant BS11 and public trust exposure for marginal cost benefit. |
| **Shared control plane, separate data plane** | Rejected after analysis. Attractive on paper, but the control plane inevitably accumulates operational metadata that is re-identifiable, for example error payloads containing prompt fragments. We judged the boundary too easy to erode accidentally over time. A boundary that requires constant vigilance is not a boundary. |
| **Cross-Tasman DR with encryption and customer-held keys** | Rejected. Encrypted personal information is still personal information, and holding the keys does not remove the disclosure. It also creates a false sense of a boundary that does not legally exist. |
| **New Zealand deployment in Australia with contractual residency terms** | Rejected. Contractual assurance is weaker than architectural impossibility, and the New Zealand North region removes the need to accept the weaker option. |

## Compliance implications

| Obligation | Implication |
|---|---|
| Privacy Act 2020 (NZ), IPP 12 | Cross-border disclosure of customer content does not occur. The narrow metrics export is assessed and documented in FB-KORU-440. |
| Privacy Act 1988 (AU), APP 8 | Same position, mirrored. |
| RBNZ BS11 | Substantially strengthens the outcomes assessment. No offshore dependency exists for New Zealand customer conversation data. |
| APRA CPS 230 | Offshoring notification obligations are simplified because customer data is not offshored. Tolerance levels are set per jurisdiction. |
| APRA CPS 234 | Information asset classification and control testing are performed per deployment, producing two independent evidence sets. |

## Enforcement

This decision is enforced in code, not in policy documents.

1. **Azure Policy** assigns an allowed-locations initiative per jurisdiction, denying resource creation outside the permitted regions. See `terraform/modules/governance`.
2. **Terraform variable validation** rejects a region value that does not match the deployment's jurisdiction.
3. **Separate state backends** per jurisdiction, with no shared credentials.
4. **Separate Entra ID application registrations and managed identities**, so a workload in one jurisdiction holds no credential that grants access in the other.
5. **Network topology** provides no route between the two deployments. There is no peering, no shared hub, and no transit.
6. **Telemetry pipeline** strips content and identifiers before any aggregate export, verified by an automated test in CI.

## Reversibility

**One way door.** Not because the engineering is impossible, but because we will tell customers where their data lives and will state this position to two regulators. Reversing it would require customer re-notification, fresh privacy assessments, regulator engagement in both jurisdictions, and would spend trust we do not wish to spend.

The correct time to challenge this decision is now, at the ARB, not later.

---

## Related documents

- [Network and connectivity](../network-and-connectivity.md) (FB-KORU-205)
- [Data architecture](../data-architecture.md) (FB-KORU-203)
- [Privacy impact assessment](../../04-compliance/privacy/privacy-impact-assessment.md) (FB-KORU-440)
- [RBNZ BS11 assessment](../../04-compliance/rbnz/bs11-outsourcing.md) (FB-KORU-420)
- [Business continuity](../../05-operations/business-continuity.md) (FB-KORU-503)
- `terraform/modules/governance`
