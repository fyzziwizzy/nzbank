# ADR-0014: A human is always reachable, and Koru always offers one

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 28 July 2026 |
| **Decision makers** | Head of Customer Experience, Chief Risk Officer, Head of Contact Centre, Chief Architect |
| **Contested** | No. |
| **Reversibility** | **Easy** technically. Culturally, this should be treated as permanent. |
| **Related risks** | KORU-R-04 vulnerable customer harm, KORU-R-01 wrong answer, KORU-R-06 believes Koru is human |

---

## Context

Automated service channels have a well-earned reputation problem, and it is not really about the automation. It is about the trap.

Customers have learned, across a decade of IVR trees and chatbots, that the machine is often not a route to help but a barrier in front of it. The escalation path is buried, the phone number is hidden, the bot loops, and the customer's actual problem, which was never something the bot could solve, goes unresolved while their frustration compounds.

The customers most damaged by this pattern are the ones with the least capacity to fight it: older customers, customers with disabilities, customers in financial distress, customers for whom English is a second language. Precisely the customers Koru is supposed to serve better.

A conversational avatar makes this worse, not better, if the escalation path is weak. It is more engaging, so customers persist longer before giving up. It is more human-seeming, so the failure feels more like a rejection.

## Decision

**A human is always reachable from Koru. Koru proactively offers a human. Reaching a human is never harder than continuing with Koru, and no metric, target or incentive in this programme may reward reducing escalation.**

### The four rules

**Rule 1. The offer is always visible.**
A persistent, always-available control to reach a person is on screen for the entire session. It is not buried in a menu, it does not require the customer to ask twice, and it is never removed, greyed out or de-emphasised, including when Koru is speaking.

**Rule 2. Koru offers proactively, and offers harder over time.**
Koru does not wait to be asked. The offer is made automatically on defined triggers, and the framing strengthens on repetition.

| Trigger | Response |
|---|---|
| Any refusal (grounding, scope, advice, security) | Offer a human as part of the refusal |
| Second consecutive misunderstanding | Offer a human |
| Any distress or vulnerability signal | Offer a human, warmly and immediately, weighted strongly |
| Any advice-seeking utterance | Offer a human as the primary path |
| Any complaint expression | Offer a human, and record a complaint regardless of what the customer chooses |
| Suspected scam or fraud | Offer a human, prioritised, and route to the specialist queue |
| Third turn without measurable progress on the customer's goal | Offer a human |
| Repeated AI-disclosure drift (ADR-0012) | Offer a human |
| Customer expresses frustration | Offer a human |

**Rule 3. The handoff carries context, and it carries it forward not sideways.**
The customer does not repeat themselves. The Kaitiaki Desk specialist receives the transcript, the customer's stated goal, what Koru already tried, what it refused and why, any vulnerability flags, and the customer's verified identity. The specialist opens the conversation knowing the situation.

If context transfer fails for any reason, **the handoff still happens**. A human without context is vastly better than no human. Context is an enhancement to the handoff, never a precondition for it.

**Rule 4. If no human is available, Koru says so honestly and takes responsibility for the follow up.**
Outside hours or during a queue surge, Koru does not pretend, does not loop, and does not hand the problem back to the customer. It states the position plainly, offers a scheduled callback at a time the customer chooses, records the commitment, and confirms it. The callback is a tracked obligation, not a suggestion.

```
I can't reach anyone from the team right now, and I don't want to leave you
without an answer.

I can book you a call back. There's a slot at 8:15 tomorrow morning, or
just after 5 if that's easier. Whoever calls will already know what we've
talked about, so you won't have to start again.
```

### The metrics rule

This is the part that makes the other three real, and it is a governance decision as much as an architectural one.

**Containment rate is not a target for this programme.** It is measured as a diagnostic, never set as an objective, and it does not appear in any individual or team performance measure connected to Koru.

The reason is simple. If anyone is rewarded for reducing escalation, the escalation path will erode, gradually, through a series of individually reasonable decisions. Nobody will decide to trap customers. It will just slowly become slightly harder to reach a person, one optimisation at a time.

What we measure instead:

| Measured | Direction | Why |
|---|---|---|
| **Escalation success rate** | Maximise, target >= 0.99 | Did the customer who wanted a human get one? |
| **Time to human** | Minimise | How long did it take? |
| **Resolution rate**, whoever resolved it | Maximise | Did the customer get their answer? |
| **Repeat contact within 7 days** | Minimise | Did we actually fix it? |
| Containment rate | **Diagnostic only** | Informative. Never a target |
| Refusal rate by class | Diagnostic | High grounding refusals means a corpus gap, not a customer problem |

A rising escalation rate is investigated as a possible **quality signal**, not automatically as a cost problem. Sometimes it means Koru is correctly recognising its limits, which is the system working.

### The opt-out

A customer may decline Koru entirely and permanently, in one action, without explanation. The preference persists across sessions and devices, and it is honoured everywhere. Existing channels remain fully available with no degradation, no additional steps and no re-prompting. Koru is never re-offered to a customer who has opted out unless they choose to turn it back on.

## Consequences

### Positive

- **The trap is designed out.** Customers cannot be stuck with Koru.
- **Directly bounds the top risks.** The consequence of a wrong answer, a distressed customer or a misunderstanding is capped by the availability of a person.
- **Central to the regulatory position.** Human oversight and the right to a human decision are explicit expectations under the responsible AI frameworks and are relevant to fair conduct obligations in both jurisdictions.
- **Customers use automation more, not less, when they trust they can leave it.** An escape hatch increases willingness to try.
- **Preserves the Fern Bank relationship.** The Kaitiaki Desk is the relationship, and Koru is the front door to it.

### Negative

- **Higher cost.** The escalation rate is the single largest driver of the Phase 1 Kaitiaki Desk uplift of NZ$1.8m, and refusing to target containment means we do not optimise it down.
- **Weaker headline efficiency numbers** than a programme that chases containment.
- **Staffing risk.** If the escalation rate exceeds the modelled 18 to 25 percent, the Desk is under-staffed. ARB condition C7 requires 100 percent headroom for the first 90 days for exactly this reason.
- **Some customers will escalate reflexively**, without giving Koru a chance. We accept this.

### Neutral

- The business case never relied on containment maximisation, so this constraint does not undermine it. See FB-KORU-011.

## Alternatives considered

| Option | Assessment |
|---|---|
| **Escalation on request only** | Rejected. Requires the customer to know to ask and to have the confidence to ask. Fails the customers who most need help. |
| **Escalation after a fixed number of failed turns** | Rejected as the sole mechanism. Better than nothing, but it makes the customer earn the escalation by first experiencing failure. |
| **Tiered escalation, bot then chat then phone** | Rejected. Each tier is another barrier, and the pattern is exactly what has damaged trust in automated channels. |
| **Containment as a soft target with guardrails** | Rejected. We do not believe a soft target survives contact with a cost pressure cycle. Either it is a target or it is not. |

## Compliance implications

| Obligation | Implication |
|---|---|
| CoFI fair conduct (NZ) | Directly supports fair treatment, particularly for vulnerable customers. |
| ASIC RG 271 (AU) | Complaints are captured and routed to a human regardless of channel. |
| Australia's AI Ethics Principles | Supports human-centred values, contestability, and human oversight. |
| NZ Algorithm Charter | Supports the commitment to retain human oversight of algorithmic processes. |
| ISO/IEC 42001 | Supports human oversight and intervention clauses. |
| Responsible AI (FB-KORU-431) | Provides the contestability and right-to-a-human mechanism. |

---

## Related documents

- [Customer journey, escalation and distress journeys](../../01-experience/customer-journey.md) (FB-KORU-101)
- [Conversation design, escalation language](../../01-experience/conversation-design.md) (FB-KORU-102)
- [Responsible AI assessment](../../04-compliance/ai-governance/responsible-ai-assessment.md) (FB-KORU-431)
- [Business case](../../00-executive/business-case.md) (FB-KORU-011)
- [ADR-0011 No personal advice](ADR-0011-no-personal-advice.md)
- [ADR-0012 Mandatory AI disclosure](ADR-0012-mandatory-ai-disclosure.md)
