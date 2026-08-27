# ADR-0009: Abstract the model interface to preserve portability

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 10 July 2026 |
| **Decision makers** | Chief Architect, Head of Platform Engineering, Head of Procurement |
| **Contested** | Yes. Engineering argued abstraction would cost capability and add complexity for a portability we would never exercise. |
| **Reversibility** | **Moderate.** |
| **Related risks** | KORU-R-03 vendor concentration |

---

## Context

ADR-0001 commits Koru to Azure and names the resulting concentration as a Board-level accepted risk. That acceptance is only honest if we have genuinely reduced the switching cost where reducing it is cheap.

Both CPS 230 and BS11 expect a regulated entity to understand and manage its exit position for a material service arrangement. "We could not leave" is not an acceptable answer. Neither is a theoretical exit plan that has never been tested and would take three years.

The engineering objection is real and worth stating fairly: abstraction layers over rapidly evolving AI APIs tend to lag the underlying capability, calcify around a lowest common denominator, and add indirection that developers route around under delivery pressure. Many "cloud agnostic" abstractions have ended up being neither agnostic nor useful.

## Decision

**The Reasoning Plane is written against an internal model interface, not against a vendor SDK. The abstraction is deliberately narrow: it covers invocation, not capability.**

### What the abstraction covers

| Covered | Not covered |
|---|---|
| Request and response shape for chat completion | Vendor-specific advanced features |
| Streaming token interface | Vendor-specific tuning parameters |
| Tool and function calling schema | Vendor-specific tool execution semantics |
| Embedding generation | Vendor-specific embedding options |
| Token accounting and cost attribution | |
| Model identity, version and routing metadata | |
| Timeout, retry and circuit breaker behaviour | |
| Error taxonomy normalisation | |

The rule we applied: **abstract the shape, not the ceiling.** Where a vendor capability is genuinely differentiating and we want it, we use it directly and record it as a named portability debt, rather than pretending it does not exist or building a fake generic version of it.

### Named portability debts

Honesty about what would actually hurt to move:

| Dependency | Portability | Note |
|---|---|---|
| Chat completion and streaming | **Portable** | Every credible provider offers a compatible shape |
| Embeddings | **Portable** | Re-embedding the corpus is a batch job, roughly 6 hours |
| Tool calling | **Mostly portable** | Schema differences are mechanical |
| Content Safety, Prompt Shields, groundedness scoring | **Partially portable** | Would need replacement or self-build. Roughly 8 to 12 weeks |
| Azure AI Search hybrid and semantic ranking | **Partially portable** | Corpus is owned in source form. Re-indexing elsewhere is roughly 4 to 6 weeks |
| **Real-time avatar synthesis** | **Poorly portable** | The genuine lock-in. Few comparable providers, and none identical |
| Streaming speech to text | **Portable** | Multiple credible providers |

**The avatar synthesis dependency is the real one.** We do not hide it. Our exit position is not "swap the avatar vendor", it is "descend to the text and voice fallback that the architecture already supports", which is why that fallback is a first class part of the design rather than an emergency measure.

## Consequences

### Positive

- **A credible, costed exit position** for the CPS 230 and BS11 assessments, rather than an aspirational one.
- **Model swapping within Azure is trivial**, which we will do routinely as models are deprecated and superseded. The abstraction pays for itself here long before any vendor exit.
- **A second provider can be run in shadow mode** for evaluation without touching the Reasoning Plane. This is how we will benchmark challenger models under FB-KORU-430.
- **Testability.** The Reasoning Plane can be tested against a deterministic mock, which makes the evaluation harness far more useful.
- **Cost attribution and token accounting are centralised** rather than scattered across call sites.

### Negative

- **Real complexity cost.** An additional layer to build, maintain and keep current as vendor APIs change.
- **Capability lag.** A new vendor feature is not available to the Reasoning Plane until the interface is extended. We mitigate this by allowing direct use with recorded debt, but that partially undermines the abstraction.
- **The engineering objection may prove right.** If we never exercise portability, this is pure overhead. We accept that possibility, because the alternative is an exit story we cannot substantiate to a regulator.

### Neutral

- Negligible runtime overhead.

## Alternatives considered

| Option | Assessment |
|---|---|
| **Direct vendor SDK usage** | Rejected. Simplest and fastest, but leaves no defensible exit position, and makes even in-vendor model changes more invasive than they need to be. |
| **Full multi-provider abstraction with active-active** | Rejected. Would require maintaining two production-grade safety, evaluation and grounding stacks. The operational risk of running two immature paths exceeds the concentration risk of one mature one, and the cost is not justified for a non-critical capability. |
| **Third-party abstraction framework** | Rejected. Substitutes one vendor dependency for another, in a less mature and less accountable part of the supply chain, and introduces a dependency we cannot assess to CPS 234 standard. |
| **Abstraction plus a permanently warm second provider** | **Deferred.** This is the strongest portability position and the most expensive. Deferred pending the Board's response to KORU-R-03. If the Board finds the concentration risk unacceptable, this is the answer, and it is costed in FB-KORU-601. |

## Exit testing

An exit plan that has never been executed is a document, not a plan. We commit to proving it.

| Test | Frequency | Evidence |
|---|---|---|
| Model swap within provider, in production | Quarterly, as part of normal model lifecycle | Change record and evaluation comparison |
| Alternate provider invoked in shadow mode against the evaluation suite | Half yearly | Benchmark report |
| Corpus re-embedding and re-indexing to an alternate search platform, in a test environment | Annually | Timed restore evidence |
| Full descent to the text-only fallback, in production, for a limited cohort | Annually, as part of continuity testing | Continuity test evidence, FB-KORU-503 |

The last one is the important one. It is the only exit test that proves customers can still be served.

## Compliance implications

| Obligation | Implication |
|---|---|
| APRA CPS 230 | Supports the exit strategy and transition requirements for a material service arrangement. Provides a costed, tested position. |
| RBNZ BS11 | Contributes to the separation plan by demonstrating the New Zealand entity can continue to serve customers without the incumbent AI provider. |
| APRA CPS 234 | Reduces the assurance burden of adding a second provider by keeping the safety controls provider-independent (see ADR-0006). |

---

## Related documents

- [ADR-0001 Azure as AI platform](ADR-0001-azure-as-ai-platform.md)
- [AI architecture](../ai-architecture.md) (FB-KORU-202)
- [Business continuity and exit](../../05-operations/business-continuity.md) (FB-KORU-503)
- [APRA CPS 230 assessment](../../04-compliance/apra/cps-230-operational-risk.md) (FB-KORU-410)
- [Cost model](../../06-delivery/cost-model.md) (FB-KORU-601)
