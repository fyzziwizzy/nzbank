# ADR-0007: Grounded or silent

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 3 July 2026 |
| **Decision makers** | Chief Architect, Head of Model Risk, Head of Compliance, Head of Product |
| **Contested** | No. The evaluation evidence settled it quickly. |
| **Reversibility** | **Easy.** Threshold configuration. Which is precisely why the governance around it must be strong. |
| **Related risks** | KORU-R-01 wrong answer, KORU-R-08 stale corpus |

---

## Context

A frontier language model has absorbed a great deal about retail banking. Asked about overdraft fees, credit card interest calculation or how a term deposit works, it will answer fluently, plausibly and immediately.

It will also, some of the time, be wrong. Not obviously wrong. Wrong in the way that reads exactly like right.

During Phase 0 evaluation we ran an un-grounded configuration against a 400 question set drawn from real contact centre enquiries, scored by product specialists.

| Configuration | Answered | Materially correct | Plausible but materially wrong | Refused |
|---|---|---|---|---|
| Un-grounded, model knowledge only | 96 percent | 71 percent | **25 percent** | 4 percent |
| Grounded, retrieval required | 78 percent | 96 percent | **1 percent** | 22 percent |

The failure mode in the un-grounded configuration was consistent and instructive. The model produced answers that were correct **for retail banking in general** and wrong **for Fern Bank specifically**. It invented a fee threshold that sounded exactly like an industry-standard one. It described a dispute process that matched a large competitor's. It quoted a notice period that was correct in Australia and wrong in New Zealand.

None of these are hallucinations in the whimsical sense. They are confident, well-calibrated statements about a bank that is not us.

At conversational speed and conversational scale, that is a conduct failure factory.

## Decision

**Koru may not make a substantive statement about a Fern Bank product, fee, rate, term, entitlement, process or obligation unless that statement is supported by a retrieved, approved, currently-valid source. If groundedness falls below threshold, Koru says it does not know and offers a human.**

### The rule, precisely

| Statement class | Grounding required | Example |
|---|---|---|
| Fern Bank product, fee, rate, term, condition | **Mandatory.** Approved corpus source, cited | "The monthly account fee is..." |
| Customer's own account data | **Mandatory.** Live Fern Core response, never model memory | "Your balance is..." |
| Fern Bank process or how to do something | **Mandatory.** Approved corpus source | "To dispute a transaction you..." |
| Regulatory or legal statement | **Mandatory,** plus a refusal preference. Prefer handing to a human | "Your rights under the ePayments Code..." |
| General financial concept, no Fern Bank specificity | Permitted un-grounded, with a generality marker | "Interest is what a lender charges to..." |
| Conversational, empathetic, procedural language | Not applicable | "I'm sorry to hear that. Let me help." |

The distinction that makes this workable: **Koru may explain a concept, but may not assert a fact about Fern Bank.** "A term deposit locks your money away for a fixed period in exchange for a fixed rate" needs no source. "Our six month term deposit rate is 4.35 percent" needs a source, a version and a citation.

### Enforcement

Enforced in the Assurance Plane outbound chain (ADR-0006), independently of the model:

1. **Groundedness scoring.** The generated response is scored against the retrieved context. Threshold **0.95**. Below threshold, the response is suppressed entirely and replaced with a refusal.
2. **Citation binding.** Every sentence classified as a Fern Bank factual assertion must map to a retrieved chunk. An orphan assertion suppresses the response.
3. **Numeric verification.** Every number, rate, percentage, date and dollar figure in the response is string-matched back to the source. A number that does not appear in the retrieved context suppresses the response. This is a blunt control and it catches the most damaging errors.
4. **Corpus currency.** Every retrieved chunk carries a validity window and an owner. An expired chunk is not retrieved. If retrieval returns nothing valid, Koru refuses rather than falling back to model knowledge. This addresses KORU-R-08.
5. **Citations are shown, not just held.** The on-screen panel displays the source alongside Koru's spoken answer, so the customer can verify without asking.

### The refusal

When grounding fails, Koru does not improvise. It says a version of:

```
I don't want to guess at that, because getting it wrong could cost you money.

I can't find a current Fern Bank source that answers it, so let me put you
through to someone who can give you a proper answer. It'll take about a minute.
```

The refusal is deliberately honest about *why*. Customers tolerate "I don't know" far better than they tolerate being misled, and telling them the reason preserves trust in every answer Koru *does* give.

## Consequences

### Positive

- **Material error rate falls from 25 percent to 1 percent** on the evaluation set. This is the single largest risk reduction in the design.
- **Every factual answer is traceable to a versioned source.** In a complaint or a dispute, we can show exactly what Koru said and exactly what it was based on, from the Ledger.
- **The corpus becomes the control point.** Product owners control what Koru can say by controlling what is published. That is a governance model banks already understand, and it puts the authority with the people accountable for the product.
- **A withdrawn product genuinely disappears.** Expire the corpus entry and Koru stops discussing it, immediately and everywhere.
- **Model-independent.** Because grounding is checked externally, a model change cannot silently degrade factual accuracy.

### Negative

- **22 percent of questions go unanswered** that a customer might reasonably expect answered. Some of these are questions where the model would in fact have been right. We are paying real customer satisfaction for the 1 percent.
- **Higher escalation rate**, and therefore higher Kaitiaki Desk cost. This is a direct driver of the 18 to 25 percent escalation model.
- **The corpus becomes critical infrastructure.** Gaps in the corpus are now customer-visible as refusals. This creates a real, ongoing content operations burden that must be funded.
- **Retrieval latency** is on the critical path for most turns.
- **Frustration risk.** A customer asked something reasonable and got "I don't know" from a system that clearly could have guessed.

### Neutral

- Conversational quality is unaffected. Grounding constrains claims, not warmth.

## Alternatives considered

| Option | Assessment |
|---|---|
| **Un-grounded with a disclaimer** | Rejected. A disclaimer does not cure a materially incorrect statement about a fee, and would not be accepted as a control by a conduct regulator. It transfers risk to the customer, which is the opposite of the obligation. |
| **Grounded with un-grounded fallback** | Rejected, and this was the tempting option. It preserves answer rate, but the fallback fires precisely when the corpus is weakest, so the un-grounded answer is *most* likely to be wrong exactly when it is *most* likely to be used. The failure modes are correlated in the worst direction. |
| **Lower threshold, for example 0.85** | Rejected for Phase 1. Raises answer rate by roughly 9 percentage points and raises material error rate to approximately 4 percent. Revisit with production evidence, as a governed change under ARB condition C9. |
| **Human review of every response** | Rejected as unscalable, retained for specific high-risk intents where the turn is routed to a human by design. |

## Governance of the threshold

Because this decision is trivially reversible in configuration, the governance around the threshold matters more than the threshold itself.

| Control | Detail |
|---|---|
| Threshold ownership | Head of Model Risk, not product or engineering |
| Change authority | Any change to the groundedness threshold, the numeric verification rule or the citation requirement is an ARB change under condition C9 |
| Change record | Threshold changes are versioned configuration, recorded in the Ledger, and appear in the monthly assurance report |
| Monitoring | Groundedness distribution, refusal rate and refusal reason are reported monthly to the Technology and Operational Risk Committee |
| Alerting | A sustained shift in refusal rate of more than 5 percentage points pages the on-call model risk analyst, because it usually indicates corpus decay rather than model change |

## Compliance implications

| Obligation | Implication |
|---|---|
| CoFI fair conduct (NZ), ASIC RG 271 (AU) | Materially reduces the risk of misleading a customer about a product or a right. Refusal is a fair outcome, misinformation is not. |
| APRA CPG 235 | Makes the retrieval corpus a governed data asset with owners, quality measures and lifecycle management. |
| Model risk (FB-KORU-430) | Provides an objective, measurable output quality control independent of the model. |
| Privacy | Grounding reduces the risk of the model generating plausible but fabricated statements about a customer's own circumstances. |

---

## Related documents

- [AI architecture](../ai-architecture.md) (FB-KORU-202)
- [Conversation design, refusal taxonomy](../../01-experience/conversation-design.md) (FB-KORU-102)
- [Data architecture, corpus governance](../data-architecture.md) (FB-KORU-203)
- [Model risk management](../../04-compliance/ai-governance/model-risk-management.md) (FB-KORU-430)
- [ADR-0006 Assurance Plane as a service](ADR-0006-assurance-plane-as-a-service.md)
