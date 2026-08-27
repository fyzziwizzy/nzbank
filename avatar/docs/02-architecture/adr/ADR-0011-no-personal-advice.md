# ADR-0011: Koru does not give personal financial advice

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 17 July 2026 |
| **Decision makers** | General Counsel, Head of Compliance (both jurisdictions), Chief Architect, Head of Product |
| **Contested** | No, on the principle. Yes, on where exactly the line sits. |
| **Reversibility** | **Easy** technically. Requires licensing work, not engineering work. |
| **Related risks** | KORU-R-04 vulnerable customer harm |

---

## Context

Giving personal financial advice is a licensed, duty-bearing activity in both jurisdictions.

In New Zealand, regulated financial advice is subject to the Financial Markets Conduct Act regime, and a person giving it must be engaged by a licensed Financial Advice Provider, must comply with the Code of Professional Conduct, and owes duties including giving priority to the client's interests. In Australia, personal advice attracts obligations under the Corporations Act including the best interests duty and the provision of a Statement of Advice.

Neither regime was drafted with a conversational avatar in mind, and neither offers a comfortable answer to the question of who is the adviser when the advice is generated.

The practical problem is worse than the legal one. **Customers do not respect the boundary, and often cannot see it.** The distance between a permitted question and a prohibited one is often a single word:

| Customer says | Category |
|---|---|
| "What's my balance?" | Information |
| "What's the interest rate on your savings account?" | Information, product |
| "Which of your accounts pays the most interest?" | Factual comparison, borderline |
| "Should I move my money to the savings account?" | **Personal advice** |
| "Can I afford this?" | **Personal advice** |
| "Am I going to be okay?" | **Personal advice, and something more** |

The last one is not a product question. It is a person who is frightened, and a system that answers it well has done something wonderful and possibly unlawful, and a system that answers it badly has done real harm.

## Decision

**Koru does not provide personal financial advice, financial product advice, or any recommendation, opinion or guidance intended to influence a customer's decision about a financial product. Koru provides factual information, and where a customer seeks advice, Koru says so plainly and routes them to a qualified human.**

### The boundary, operationalised

| Class | Permitted | Example response |
|---|---|---|
| **Factual, own data** | Yes | "Your balance is 2,340 dollars." |
| **Factual, product** | Yes, grounded per ADR-0007 | "That account pays 3.1 percent on balances over 5,000 dollars." |
| **Factual comparison** | Yes, if it is a complete and neutral statement of published facts, with no ranking language and no recommendation | "The Everyday account pays 0.1 percent. The Saver account pays 3.1 percent with a 32 day notice period." |
| **General financial concept** | Yes, generic and non-personalised | "Compound interest means you earn interest on the interest already earned." |
| **Recommendation** | **No** | Refuse and route |
| **Suitability or affordability judgement** | **No** | Refuse and route |
| **Opinion on a customer's situation** | **No** | Refuse and route |
| **Prediction or forecast** | **No** | Refuse and route |

The distinction we apply operationally: **Koru may state what is true. Koru may not state what is best.**

### Enforcement

Advice detection runs twice, independently, in the Assurance Plane (ADR-0006):

1. **Inbound.** An advice-intent classifier on the customer's utterance. Catches the customer asking for advice.
2. **Outbound.** An advice-content classifier on Koru's generated response, independent of the inbound result. Catches Koru drifting into advice while answering a legitimate question.

The outbound check is the important one. The most likely path to an advice breach is not a customer asking "what should I do". It is a customer asking a reasonable factual question and the model, trying to be helpful, adding a sentence of recommendation at the end. That sentence is generated after the inbound check has already passed.

The outbound classifier is tuned to be **deliberately over-sensitive**. A false positive costs a customer a slightly stilted answer. A false negative is a licensing breach.

### The refusal

Koru is honest about why, because "I can't help with that" from a system that clearly understood the question is corrosive to trust:

```
That's a question about what's right for you, and I'm not able to advise on
that. It's not that I don't want to help. Advice about your money needs
someone qualified who can look at your whole situation, and that isn't me.

I can put you through to someone who can, or book you a time that suits.
Would either of those help?
```

### The distress case

If the advice-seeking utterance also carries distress signals, the advice refusal is **suppressed in favour of the vulnerability protocol**. A customer asking "am I going to be okay" gets a human, warmly and quickly. They do not get a lecture about licensing.

This ordering is explicit in the Assurance Plane policy and is tested. It is the single most important interaction ordering rule in the system.

## Consequences

### Positive

- **No licensing exposure** in either jurisdiction for Phase 1.
- **No best interests duty** attaches to Koru's outputs, which removes an entire category of conduct risk that would be extremely difficult to discharge through a generative system.
- **Clear, testable boundary** that can be evidenced to the FMA and ASIC.
- **Protects vulnerable customers** from a confident, plausible, unqualified recommendation delivered by something that sounds authoritative.
- **The routing is a feature.** A customer who wants advice reaches a qualified adviser, which is a better outcome and a commercial opportunity.

### Negative

- **Customers will be frustrated.** A meaningful proportion of questions people most want answered are advice questions. Koru will refuse them.
- **Over-sensitive classification will produce false positives**, refusing questions that were genuinely factual. We accept this asymmetry deliberately.
- **The comparison case is uncomfortable.** Neutral factual comparison is permitted but sits close to the line, and our classifier will sometimes get it wrong in both directions.
- **Higher escalation rate**, contributing to the 18 to 25 percent model.

### Neutral

- Phase 4 contemplates guided budgeting and coaching, which would require a licensing determination and possibly a licensed adviser in the loop. This decision does not preclude it, it defers it properly.

## Alternatives considered

| Option | Assessment |
|---|---|
| **General advice with a warning** | Rejected. General advice is still a regulated activity in Australia with its own obligations, and the boundary between general and personal advice is precisely the boundary a conversational system is worst at holding. A warning does not cure a personalised recommendation. |
| **Personal advice under a licence with a human in the loop** | Rejected for Phase 1, viable for Phase 4. Would require a licensed adviser to review each piece of advice, which defeats the latency and scale premise. |
| **Advice restricted to a narrow, scripted set** | Rejected. Scripted advice is still advice, and building a narrow permitted set creates a boundary that must be policed with the same classifier anyway, for less benefit. |
| **Decision tools that inform without advising, for example a calculator** | **Accepted as a complementary approach.** Koru may surface a calculator or comparison tool on screen and let the customer operate it. The customer reaches their own conclusion using a tool, and Koru has not advised. This is a good pattern and is used in the customer journey design. |

## Compliance implications

| Obligation | Implication |
|---|---|
| Financial Markets Conduct Act regime (NZ) | Koru does not give regulated financial advice. No Financial Advice Provider obligations attach to its outputs. |
| Corporations Act (AU) | Koru does not provide financial product advice, personal or general. No best interests duty, no Statement of Advice obligation. |
| CoFI fair conduct (NZ) | Routing an advice-seeking customer to a qualified human is a fair conduct outcome and is designed to be timely. |
| ASIC RG 271 | Customer dissatisfaction with a refusal is captured in the complaints process, with the refusal reason available from the Ledger. |

**Assumption.** This position has been reviewed by internal Legal. External counsel opinion in both jurisdictions is **Planned** before Phase 1 customer traffic. Owner: General Counsel. Resolve by 30 November 2026.

---

## Related documents

- [Conversation design, refusal taxonomy](../../01-experience/conversation-design.md) (FB-KORU-102)
- [Customer journey, advice redirect and distress journeys](../../01-experience/customer-journey.md) (FB-KORU-101)
- [Regulatory landscape](../../04-compliance/regulatory-landscape.md) (FB-KORU-400)
- [ADR-0007 Grounded response only](ADR-0007-grounded-response-only.md)
- [ADR-0014 Human handoff always available](ADR-0014-human-handoff-always-available.md)
