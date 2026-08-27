# ADR-0013: Every interaction is recorded immutably and is replayable

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 24 July 2026 |
| **Decision makers** | Chief Architect, Chief Risk Officer, General Counsel, Chief Privacy Officer |
| **Contested** | Yes. Privacy argued that comprehensive recording is itself a privacy risk. That argument shaped the final design. |
| **Reversibility** | **One way door.** Once immutability is relied on for evidence, it cannot be relaxed retrospectively. |
| **Related risks** | All. The Ledger is how every other risk is investigated |

---

## Context

When something goes wrong in a conversational system, the questions arrive fast and they are specific.

*What exactly did the customer ask? What did Koru say back? What sources was that based on? Which model version produced it? Did the groundedness check pass, and with what score? Was a guardrail triggered? Was a human offered? Did the customer accept? Was this the only customer affected, or ten thousand?*

If the answer to any of these is "we would have to reconstruct that", the institution is in serious trouble, because these questions come from complaints teams, dispute resolution schemes, the FMA, ASIC, APRA, the RBNZ, the Privacy Commissioner and occasionally a court.

Generative systems make this harder than conventional software in three ways. Outputs are non-deterministic, so you cannot re-run the input and expect the same result. Behaviour depends on the model version, the prompt version, the retrieved context and the policy configuration at that moment, all of which change over time. And the failure is often the content itself rather than an error, so nothing appears in a conventional error log.

The counter-argument, made forcefully by the Privacy Officer, is that building a comprehensive, immutable, seven year record of every conversation a customer has about their money creates a concentrated, permanent, high-value corpus of sensitive personal information that cannot be deleted. That is a real privacy harm, and "we need it for compliance" is not automatically a sufficient answer.

Both positions are correct. The design below is the reconciliation.

## Decision

**Every Koru interaction is recorded to the Koru Ledger: an append-only, immutable, replayable record with a seven year retention, held in-jurisdiction, with strictly controlled access and comprehensive access logging. Audio is never retained. Retention is capped, access is minimised, and the privacy cost is treated as a cost, not as a non-issue.**

### What is recorded

| Recorded | Not recorded |
|---|---|
| Transcript of customer utterances | **Raw voice audio** |
| Transcript of Koru responses | **Rendered avatar video** |
| Speech recognition confidence per utterance | Voice characteristics or speaker embeddings |
| Assembled prompt, with PII already minimised | |
| Retrieved chunk identifiers and versions | Full corpus content, referenced not copied |
| Model identity, version, and generation parameters | |
| Every Assurance Plane decision, inbound and outbound, with scores | |
| Groundedness score and citation map | |
| Every tool call, parameters, and result status | Full downstream response payloads, referenced by correlation ID |
| Entitlement decisions | |
| Disclosure events, with type and wording version | |
| Refusals, with class and reason | |
| Escalation offers, acceptances and outcomes | |
| Vulnerability and distress protocol invocations | |
| Prompt template version and policy configuration version | |
| Latency per hop | |
| Token counts and cost | |
| Session, customer and correlation identifiers | |

**Audio is never written to durable storage.** It exists in memory for the duration of transcription and is discarded. This was the single most important concession to the privacy position, and it removes the most sensitive artefact from the record while preserving evidential value, because the transcript plus the confidence score tells us what was heard and how reliably.

### Immutability

| Property | Mechanism |
|---|---|
| Append only | Ledger writer identity holds append permission only. No update or delete role exists for any human or workload |
| Write once, read many | Azure Storage immutable blob policy, time-based retention of 7 years, locked |
| Tamper evidence | Per-record hash, chained per session, with a periodic anchor digest written separately |
| Legal hold | Applied per session on dispute, complaint or regulatory request, suspending expiry |
| Separation | The Ledger is written by a dedicated identity that no application workload assumes. The Reasoning Plane cannot write to the Ledger directly |
| Replay | A session can be reconstructed turn by turn, with the exact model, prompt, corpus and policy versions in force at that moment |

### Replayability, and its honest limit

Replay reconstructs **what happened and why**, deterministically: the input, the retrieved context, the configuration, the guardrail decisions, the output.

Replay does **not** guarantee that re-running the same input through the same model reproduces the same output. Generative models are non-deterministic and vendor-side model behaviour changes. We do not claim otherwise, and we make this limitation explicit in evidence provided to any external party, because overstating it would be worse than the limitation itself.

What we can always state with certainty is: this is the exact text Koru said, at this time, to this customer, based on these sources, under this configuration.

### Privacy controls on the Ledger

This is the reconciliation of the two positions, and it is a condition of the decision.

| Control | Detail |
|---|---|
| **PII minimisation before write** | Detected PII beyond what is necessary is redacted at the Assurance Plane, before the record is written. The Ledger holds the minimum viable record, not the maximum available one |
| **No audio, no video** | As above |
| **Access is not a role, it is a case** | No standing access exists. Access is granted per investigation, time-boxed, tied to a case reference, and expires automatically. Control KORU-C-25 |
| **Every access is logged and reviewed** | Access to the Ledger is itself an auditable event, reviewed monthly by the Privacy Officer. Access without a valid case reference is a disciplinary matter |
| **No analytics on content by default** | Aggregate analytics run on metadata and scores, not transcript content. Content analysis requires a documented purpose and Privacy Officer approval |
| **Customer access** | A customer may request their own Koru interaction records under IPP 6 and APP 12, and receives them in readable form |
| **Hard expiry** | Records expire automatically at 7 years unless under legal hold. Expiry is enforced by the storage policy, not by a job that might not run |
| **The record is disclosed** | Customers are told, at session start and in the privacy notice, that the conversation is recorded and why |

## Consequences

### Positive

- **Every regulatory and dispute question is answerable with evidence** rather than reconstruction.
- **Systematic failure detection.** If a corpus error caused Koru to misstate a fee, we can identify every affected customer precisely and remediate proactively rather than waiting for complaints.
- **Control effectiveness is provable per interaction**, which is what makes the CPS 234 and Tier 1 model validation positions work.
- **Evaluation and drift detection have a ground truth to work from.**
- **Customer trust.** "We keep a record of what Koru told you, and you can ask for it" is a genuinely reassuring statement.

### Negative

- **A concentrated store of sensitive personal information exists for seven years.** This is a real privacy cost. It is mitigated, not eliminated, and it is recorded as such in the PIA.
- **A high value breach target**, requiring the strongest controls in the platform: customer managed keys in Managed HSM, private endpoints, no standing access, and dedicated monitoring.
- **Storage and processing cost**, roughly 4 percent of platform run cost. Not material.
- **Erasure requests cannot be fully honoured** for records subject to the statutory retention. This is lawful in both jurisdictions but must be explained clearly to customers, and it is an uncomfortable conversation.
- **Write latency** is on the turn path for the guardrail decision record. Mitigated by asynchronous write with a synchronous acknowledgement of receipt.

### Neutral

- Seven years aligns with existing financial record retention under AML/CTF and AML/CFT obligations, so it introduces no new retention concept.

## Alternatives considered

| Option | Assessment |
|---|---|
| **Sampled recording, for example 5 percent** | Rejected. The interaction that matters is always the one that was not sampled. Useless for dispute resolution, which is the primary purpose. |
| **Metadata only, no transcript** | Rejected. Cannot answer "what did Koru actually say to me", which is the central question in almost every complaint. |
| **Retain audio as well** | **Rejected, and this was the right call.** Marginal evidential benefit over an accurate transcript with confidence scores, at a substantial privacy cost, a substantial storage cost, and the creation of a voice corpus that would itself become a deepfake source. |
| **Mutable store with audit logging** | Rejected. Audit logs on a mutable store are weaker evidence than an immutable store, and the difference matters precisely when it is contested. |
| **Shorter retention, for example 2 years** | Rejected. Inconsistent with the 7 year financial record retention obligations, and disputes routinely surface after 2 years. |

## Compliance implications

| Obligation | Implication |
|---|---|
| APRA CPS 234 | Provides the evidence base for systematic control effectiveness testing. |
| APRA CPS 230 | Supports incident investigation and the 24 hour notification assessment. |
| RBNZ BS11 | Supports the ability to provide a statutory manager and the Reserve Bank with data needed for crisis management. |
| AML/CTF (AU) and AML/CFT (NZ) | Aligns with 7 year record keeping. |
| Privacy Act 2020 (NZ) IPP 5, 6, 9 | Security, access and retention addressed. Recorded as a residual risk in the PIA. |
| Privacy Act 1988 (AU) APP 11, 12 | Same. |
| ASIC RG 271, external dispute resolution | Provides authoritative evidence for complaint and dispute handling. |

## Reversibility

**One way door.** Once regulators, dispute schemes and customers rely on the Ledger as authoritative evidence, reducing its scope or immutability would be a material weakening of a stated control position, and would require regulator engagement.

The design should therefore be challenged now, particularly the seven year retention and the decision to record full transcripts, which are the two elements carrying the privacy cost.

---

## Related documents

- [Data architecture, the Koru Ledger](../data-architecture.md) (FB-KORU-203)
- [Privacy impact assessment](../../04-compliance/privacy/privacy-impact-assessment.md) (FB-KORU-440)
- [Observability and evaluation](../../05-operations/observability-and-evaluation.md) (FB-KORU-501)
- [Incident response, evidence preservation](../../05-operations/incident-response.md) (FB-KORU-502)
- [ADR-0008 No customer data in training](ADR-0008-no-customer-data-in-training.md)
