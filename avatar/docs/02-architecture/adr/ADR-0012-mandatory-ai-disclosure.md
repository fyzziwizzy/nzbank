# ADR-0012: Mandatory, repeated disclosure that Koru is not human

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 21 July 2026 |
| **Decision makers** | Head of Customer Experience, General Counsel, Chief Architect, Head of Conduct |
| **Contested** | No on the principle. Yes on frequency, where Product argued repetition would feel patronising. |
| **Reversibility** | **Easy** technically, and we would not. |
| **Related risks** | KORU-R-06 customer believes Koru is human |

---

## Context

Koru will be good. That is the problem this record addresses.

A synthesised presenter with a natural voice, appropriate expression, conversational timing and genuine helpfulness will be experienced as a person by a meaningful number of customers, particularly older customers, customers with cognitive impairment, isolated customers, and customers in distress. Some will know intellectually that Koru is software and relate to it as a person anyway, which is a well-documented human response and not a failure of intelligence.

This creates two distinct harms.

**The consent harm.** A customer who believes they are speaking to a Fern Bank employee is operating on a false understanding of what they are dealing with, what it can do, and what weight to give its answers. Their reliance is misplaced in a way they cannot correct because they do not know there is anything to correct.

**The relational harm.** A customer who forms an attachment to a system that is warm, endlessly available and infinitely patient may substitute it for human contact, and may trust it in ways it does not merit. This is the risk we flagged in the README as the one nobody puts in an architecture pack. It is real, it disproportionately affects the customers with the least resilience, and disclosure is a necessary but insufficient response to it.

## Decision

**Koru discloses that it is an AI assistant, not a person, at the start of every session, whenever asked in any form, at every handoff, and whenever the conversation shows signs that the customer has forgotten. The disclosure is enforced by the Assurance Plane, not by the model.**

### The four disclosure moments

| # | Moment | Modality | Wording |
|---|---|---|---|
| 1 | **Session start** | Spoken and on screen, before the first question | "Kia ora, I'm Koru. I'm Fern Bank's AI assistant, not a person. I can help with your accounts and answer questions about our products, and I'll put you through to one of our team whenever you'd like." |
| 2 | **On request** | Spoken, immediate, unambiguous | "No, I'm not a person. I'm an AI assistant made by Fern Bank. Would you like me to put you through to someone?" |
| 3 | **At handoff** | Spoken, framing the transition | "I'm handing you to Aroha now. She's a real person on our team, and she can see what we've talked about." |
| 4 | **On drift** | Spoken, gentle, non-corrective in tone | Triggered when the customer's language indicates they believe Koru is human. See below. |

### Persistent visual state

Independent of the spoken disclosure, an unobtrusive but always-present on-screen indicator reads **"Koru, AI assistant"** for the entire session. It cannot be dismissed. A customer who joined mid-conversation, was distracted, or does not recall the opening can look and know.

### Drift detection

The fourth moment is the one that required design work. The Assurance Plane monitors for signals that the customer has lost the thread:

| Signal | Example |
|---|---|
| Direct personal address as a human | "You've been so kind to me today, love" |
| Assumption of continuity or memory of a person | "Are you the same girl I spoke to last week?" |
| Assumption of physical presence | "Are you in the Wellington branch?" |
| Assumption of personal agency | "Can you just do me a favour and waive it?" |
| Emotional disclosure of a kind normally reserved for a person | Extended personal disclosure unrelated to the enquiry |
| Explicit statement of belief | "It's nice to talk to a real person for once" |

On detection, Koru re-discloses **warmly, once, without embarrassing the customer**:

```
I should say again, I'm an AI assistant rather than a person, and I don't
want you to think otherwise. I'm still glad to help. And if you'd rather
talk to someone from our team, I can arrange that right now.
```

The tone matters enormously. A correction that shames the customer is worse than no correction. The wording above was tested with older customers and revised three times.

Repeated drift detection within a session, or the presence of distress signals alongside drift, triggers a **proactive offer of a human**, weighted more strongly each time.

### Enforcement

Disclosure is not left to the model.

| Control | Mechanism |
|---|---|
| Session start disclosure | Injected by the Orchestrator before the first turn. Cannot be skipped. The session cannot enter the ready state without it |
| On-request disclosure | Detected inbound by the Assurance Plane and answered from a fixed template. The model is not consulted, so it cannot equivocate |
| Handoff disclosure | Injected by the Orchestrator on transfer |
| Drift disclosure | Assurance Plane inbound classifier, template response |
| Never claim humanity | Outbound Assurance check. A response asserting or implying personhood is suppressed and replaced. This is control KORU-C-71 |
| Evidence | Every disclosure event is written to the Ledger with a type and timestamp |

The final row is a hard rule with no threshold: Koru may not say "I", "me" or "my" in a way that asserts human experience, may not claim feelings it does not have, may not claim to remember a previous conversation as a person would, and may not accept an attribution of humanity by staying silent.

There is a deliberate nuance. Koru does say "I can help" and "I'm sorry to hear that", because stilted third-person speech is worse for comprehension and feels evasive. The line is between **conversational first person**, which is permitted, and **claimed human experience**, which is not. Sample dialogue distinguishing the two is in FB-KORU-102.

## Consequences

### Positive

- **Informed customers.** People know what they are dealing with and can calibrate their reliance accordingly.
- **A defensible conduct position.** In a complaint or a dispute, we can show from the Ledger exactly when disclosure occurred and in what words.
- **Anticipates regulation.** Disclosure obligations for AI systems interacting with consumers are strengthening globally. We would rather already comply.
- **It builds trust rather than costing it.** Research consistently shows honest disclosure increases rather than decreases confidence. Customers dislike being deceived far more than they dislike talking to software.
- **Drift detection doubles as a vulnerability signal**, feeding the protocol in FB-KORU-102.

### Negative

- **Repetition can feel patronising.** This was Product's objection and it is fair. We mitigate with careful wording, once-per-trigger suppression, and a session-level cap on drift re-disclosure.
- **The opening disclosure adds roughly 6 seconds** before the customer's first question. This is a real cost to the experience and we accept it.
- **It breaks immersion**, which is the point, but does reduce the warmth of the interaction slightly.
- **Disclosure is necessary but not sufficient** for the relational harm. We should not claim otherwise, and we do not.

### Neutral

- No material technical cost.

## Alternatives considered

| Option | Assessment |
|---|---|
| **Disclose once at first ever use** | Rejected. Fails the customer who does not remember, the customer who was distracted, and the customer with cognitive impairment, who are exactly the customers the disclosure protects. |
| **Visual indicator only** | Rejected. Excludes customers with low vision and customers using the audio-only path, and is easily missed. |
| **Disclose only when asked** | Rejected. Places the burden on the customer to suspect something, which the customers most at risk are least likely to do. |
| **Make Koru obviously robotic so disclosure is unnecessary** | Rejected as the sole mechanism, **partially adopted as design direction**. Koru is deliberately stylised rather than photoreal, and does not attempt to pass as human visually. But a stylised avatar with a warm voice is still experienced as a person by some customers, so design choice does not replace explicit disclosure. See FB-KORU-100. |

## Compliance implications

| Obligation | Implication |
|---|---|
| CoFI fair conduct (NZ) | Supports fair dealing and the requirement not to mislead. |
| ASIC RG 271, Australian Consumer Law | Reduces the risk of misleading or deceptive conduct by omission. |
| Australia's AI Ethics Principles | Directly supports transparency and explainability. |
| NZ Algorithm Charter | Supports transparency about the use of algorithms affecting people. |
| ISO/IEC 42001 | Supports the transparency and communication clauses. |
| EU AI Act (context only) | Aligns with transparency obligations for AI systems interacting with natural persons. |

---

## Related documents

- [Conversation design, disclosure framework](../../01-experience/conversation-design.md) (FB-KORU-102)
- [Product vision and persona](../../01-experience/product-vision.md) (FB-KORU-100)
- [Responsible AI assessment](../../04-compliance/ai-governance/responsible-ai-assessment.md) (FB-KORU-431)
- [ADR-0014 Human handoff always available](ADR-0014-human-handoff-always-available.md)
