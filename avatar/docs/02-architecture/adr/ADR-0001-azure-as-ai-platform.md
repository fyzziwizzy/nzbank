# ADR-0001: Microsoft Azure as the AI and hosting platform

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 12 June 2026 |
| **Decision makers** | Chief Architect, CTO, CISO, Head of Procurement |
| **Contested** | Yes. Two of six voting members initially preferred a multi-cloud posture. |
| **Reversibility** | **Hard.** Multi-quarter re-architecture and contract renegotiation. |
| **Related risks** | KORU-R-03 vendor concentration |

---

## Context

Koru requires an unusually broad set of capabilities to be co-located, low latency and jointly governable:

1. Real-time streaming speech to text with sub-300ms partial results
2. Real-time text to speech avatar synthesis with video, streamed over WebRTC
3. Frontier-class language models with enterprise data handling commitments
4. Content safety services including prompt injection defence and groundedness scoring
5. Hybrid vector and keyword retrieval with semantic ranking
6. All of the above available in an Australian region and a New Zealand region, with data residency commitments we can put in front of APRA and the RBNZ

Fern Bank's existing enterprise landing zones, identity platform, security tooling and operational practice are already on Azure. Fern Core connectivity, ExpressRoute circuits, Entra ID, Defender and Purview are established.

The constraint that eliminated most options was not model quality. It was **the combination of avatar synthesis and jurisdictional residency**. Very few providers offer real-time avatar synthesis at all, and fewer still offer it in a New Zealand region under contractual residency terms.

## Decision

**We will build Koru on Microsoft Azure as a single primary platform, and we will treat the resulting concentration as a named, accepted, Board-level risk rather than pretending to mitigate it with a multi-cloud story we would not actually execute.**

Specifically:

- Azure AI Foundry and Azure OpenAI for language models
- Azure AI Speech for streaming recognition and real-time avatar synthesis
- Azure AI Content Safety for the safety control set
- Azure AI Search for retrieval
- Azure Container Apps for the runtime
- The wider Azure platform for identity, networking, data, observability and governance

Microsoft is registered as a **material service provider** under APRA CPS 230 and recorded in the RBNZ BS11 outsourcing compendium.

## Consequences

### Positive

- One security model, one identity model, one network model, one policy engine. Every control we build applies uniformly.
- Private connectivity end to end. No component of the reasoning path traverses the public internet.
- Existing landing zone, existing ExpressRoute, existing Defender and Purview coverage. Phase 0 does not start from zero.
- A single material service provider to assess, contract, monitor and report on, rather than four.
- New Zealand North availability makes the sovereign NZ deployment in ADR-0003 possible at all.

### Negative

- **Genuine concentration risk.** A severe, prolonged Azure impairment degrades the entire Koru capability at once. This is KORU-R-03 and it is escalated to the Board for explicit acceptance in the ARB submission.
- Commercial leverage in future negotiations is reduced.
- Model roadmap is partly outside our control. A model deprecation is a forced change for us.
- Skills concentration in the engineering team.

### Neutral

- Cost is competitive but not decisively cheaper than alternatives. This was not a cost-led decision.

## Alternatives considered

| Option | Assessment |
|---|---|
| **Multi-cloud active-active** | Rejected. Doubles the control surface, the assurance burden and the cost, for a capability that is not a critical operation (see ADR-0005 and the CPS 230 assessment). We judged the added operational risk of running two immature AI stacks to exceed the concentration risk of running one mature one. |
| **Best of breed per capability** | Rejected. Would place customer audio with one provider, transcripts with another and retrieval with a third, creating multiple cross-border data flows and multiple material service provider assessments. The privacy and BS11 positions become materially harder to defend for no proportionate benefit. |
| **Self-hosted open weight models** | Rejected for Phase 1, retained as a strategic option. Removes the model dependency but transfers full model risk, safety tuning and evaluation burden to Fern Bank. We do not currently hold that capability. Revisit at Phase 2. |
| **Packaged banking avatar SaaS** | Rejected. Insufficient control over data residency, model governance and evidence generation. We could not evidence controls to APRA and the RBNZ at the depth this pack requires. |

## Compliance implications

| Obligation | Implication |
|---|---|
| APRA CPS 230 | Microsoft is a material service provider. Requires register entry, APRA notification of the arrangement, due diligence, contract minimum content including step-in rights and business continuity, ongoing monitoring, and fourth party supply chain assessment. |
| APRA CPS 230 | Concentration must be reflected in tolerance levels and in scenario testing. See FB-KORU-503. |
| RBNZ BS11 | Compendium entry required. The arrangement must not impair the ability to continue basic banking services, which is satisfied because Koru is not on the basic banking path. |
| APRA CPS 234 | Third party information security assurance required, including evidence of Microsoft's control environment. |

## Reversibility and exit

Exit is **hard but not impossible**, and the cost is bounded by three deliberate design choices:

1. The model interface is abstracted (ADR-0009), so the Reasoning Plane is not written against a vendor SDK.
2. The retrieval corpus is owned by Fern Bank in its source form, not only as vendor-side embeddings. It can be re-embedded and re-indexed elsewhere.
3. The Ledger is stored in an open format in Fern Bank controlled storage.

The genuinely hard-to-replace component is **real-time avatar synthesis**. Our documented exit position is descent to a text or voice-only grounded assistant, which the architecture supports without redesign. See FB-KORU-503.

Estimated exit effort: 9 to 12 months to a comparable capability, or 6 to 10 weeks to the degraded text-only fallback.

---

## Related documents

- [ADR-0003 Jurisdictional isolation](ADR-0003-jurisdictional-isolation.md)
- [ADR-0009 Model portability](ADR-0009-model-portability.md)
- [Cloud services catalogue](../cloud-services-catalogue.md) (FB-KORU-201)
- [APRA CPS 230 assessment](../../04-compliance/apra/cps-230-operational-risk.md) (FB-KORU-410)
- [RBNZ BS11 assessment](../../04-compliance/rbnz/bs11-outsourcing.md) (FB-KORU-420)
