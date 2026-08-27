# ADR-0005: Read-only capability before any write capability

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 26 June 2026 |
| **Decision makers** | Chief Architect, Chief Risk Officer, Head of Personal Banking |
| **Contested** | Yes. Product argued a read-only avatar would be judged underwhelming at launch. |
| **Reversibility** | **Easy.** Write capability is additive, gated by ARB approval, not by re-architecture. |
| **Related risks** | KORU-R-01 wrong answer, KORU-R-04 vulnerable customer harm |

---

## Context

The business ambition for Koru is a conversational interface that can complete tasks, not just answer questions. Freeze a card. Lodge a dispute. Move money. That is where the cost-to-serve benefit and the customer delight both live.

The counter-argument is that generative systems fail differently to the software banks are used to approving. Traditional software fails predictably and loudly. Generative systems fail plausibly and quietly. A wrong answer arrives fluent, confident, well-formed and indistinguishable in tone from a right one.

We have no operational evidence about how our guardrails perform against our own customers asking our own questions in their own words. Every number in the evaluation harness comes from datasets we constructed. That is a reasonable basis for believing the system is safe. It is not a reasonable basis for granting it the ability to move money.

## Decision

**Koru launches read-only. No capability that mutates state, moves value or creates an obligation is enabled until the read-only phase has produced evidence that the guardrails hold against real traffic.**

The boundary is enforced at three independent layers, so that a failure at any one layer does not grant write access:

| Layer | Enforcement |
|---|---|
| **Tool registry** | Only read-classified tools are registered for Phase 1. A write tool cannot be called because it does not exist in the Reasoning Plane's tool manifest. |
| **API Management** | The Koru subscription is scoped to read-only Fern Core operations. A write call is rejected at the gateway regardless of what the model attempted. |
| **Fern Entitlements** | The Koru service principal holds no write entitlement for any customer account. A write is denied at the authorisation layer even if it reached the API. |

Three layers is deliberate. A prompt injection that fully compromises the Reasoning Plane still cannot move money, because the Reasoning Plane never held the authority to do so.

### Phase boundaries

| Phase | Capability | Gate to enter |
|---|---|---|
| **Phase 1, Koru Informs** | Balances, transactions, product and fee explanation, rate questions, servicing navigation | This ARB |
| **Phase 2, Koru Assists** | Card freeze, dispute lodgement, statement requests, low-risk servicing | Fresh ARB submission with write-path threat model |
| **Phase 3, Koru Acts** | Payments and value movement inside limits | Fresh ARB submission with fraud assessment and step-up design |
| **Phase 4, Koru Advises** | Budgeting and goal coaching | Advice licensing determination in both jurisdictions |

## Consequences

### Positive

- **The blast radius of the primary risk is information, not money.** If Koru gives a wrong answer in Phase 1, a customer is misinformed, which is serious and remediable. If Koru gave a wrong answer in Phase 3, a customer could be poorer, which is serious and often not remediable.
- **We build the evidence base before we need it.** Phase 2 and Phase 3 submissions will be argued from measured groundedness, measured refusal accuracy and measured escalation behaviour across millions of real turns, not from a test harness.
- **Prompt injection becomes a containment problem rather than a catastrophe.** The worst realistic outcome of a successful injection in Phase 1 is disclosure of information the authenticated customer was already entitled to see, plus reputational damage. That is a bad day, not a solvency event.
- **The regulatory conversation is dramatically easier.** "It cannot move money" ends a category of question in a single sentence, for both APRA and the RBNZ.
- **The Kaitiaki Desk model is proven under real load** before it is asked to handle escalations that carry financial consequence.

### Negative

- **Weaker launch proposition.** Some customers, and some competitors' marketing, will find a read-only avatar unimpressive.
- **Lower Phase 1 benefit realisation.** The containment benefit is limited to enquiry traffic, which is the majority of volume but the minority of handling time.
- **Two additional ARB cycles** and the delivery overhead that comes with them.
- **Escalation rate will be higher than the eventual steady state**, because tasks Koru could technically perform must be handed to a human. This inflates the Phase 1 Kaitiaki Desk cost.

### Neutral

- The architecture is unchanged between phases. Adding write capability is a matter of registering tools, widening the API Management scope and granting entitlements, each of which is a controlled change. No plane is redesigned.

## Alternatives considered

| Option | Assessment |
|---|---|
| **Full capability at launch** | Rejected. Concentrates every category of risk at a single approval gate with no operational evidence to support it. Also creates a single, very large reputational event if it goes wrong. |
| **Read plus a small set of reversible writes, for example card freeze** | Genuinely close. Card freeze is reversible, customer-protective, and a plausible first write. Rejected for Phase 1 on the narrow ground that it still requires a write path, a write threat model and a write entitlement, and once that path exists the three-layer guarantee above weakens to a two-layer one. We would rather have the strong guarantee for one phase and then design the write path properly. Card freeze is the first capability in Phase 2. |
| **Read-only for unauthenticated customers only** | Rejected. Inverts the risk. Unauthenticated general information is the *least* sensitive use, so restricting to it would deliver almost no value. |
| **Time-boxed pilot with full capability for staff** | Adopted in part. Phase 0 includes an internal staff pilot, but against synthetic accounts only, so staff exercise the conversation without any real money being reachable. |

## Evidence required to progress to Phase 2

The Phase 2 submission must present, from real Phase 1 traffic:

| Measure | Threshold |
|---|---|
| Groundedness score, rolling 90 day | >= 0.95 |
| Unsafe response rate | <= 0.1 percent |
| Refusal accuracy (correct refusals over total refusals plus missed refusals) | >= 0.98 |
| Successful prompt injection attempts reaching a tool call | Zero, across production traffic and continuous red teaming |
| Escalation success rate (customer reached a human when one was offered) | >= 0.99 |
| Complaints attributable to Koru per 10,000 sessions | Trending down, with root cause analysis on every one |
| Vulnerable customer protocol invocations | Reviewed individually, 100 percent |

Failure to meet any threshold does not automatically block Phase 2, but requires explicit explanation and Board acceptance.

## Compliance implications

| Obligation | Implication |
|---|---|
| APRA CPS 230 | Supports the assessment that Koru is not a critical operation. A capability that cannot transact cannot disrupt a critical operation. |
| RBNZ BS11 | Basic banking services are unaffected by Koru's availability, which is central to the outcomes assessment. |
| Model risk (FB-KORU-430) | Model risk tier remains Tier 1 due to customer impact, but the consequence severity is bounded, which shapes the validation requirement proportionately. |
| Conduct (CoFI, RG 271) | Misinformation remains a conduct risk and is treated as one. The absence of transaction capability does not remove conduct obligations, and we do not argue that it does. |

## Reversibility

Easy in the engineering sense, deliberately hard in the governance sense. Adding write capability is straightforward to build and is designed to require a full ARB submission to authorise. That asymmetry is the point.

---

## Related documents

- [ARB submission, conditions C1, C5, C10](../../../ARB-SUBMISSION.md)
- [Integration architecture](../integration-architecture.md) (FB-KORU-204)
- [Model risk management](../../04-compliance/ai-governance/model-risk-management.md) (FB-KORU-430)
- [ADR-0007 Grounded response only](ADR-0007-grounded-response-only.md)
- [ADR-0011 No personal advice](ADR-0011-no-personal-advice.md)
