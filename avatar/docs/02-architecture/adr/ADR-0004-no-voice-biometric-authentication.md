# ADR-0004: Voice is never an authentication factor

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 24 June 2026 |
| **Decision makers** | CISO, Chief Architect, Head of Fraud, General Counsel |
| **Contested** | No. Unanimous, and the fastest decision in this set. |
| **Reversibility** | **One way door.** We will state this publicly. Reversing it would require repudiating a stated security position. |
| **Related risks** | KORU-R-05 deepfaked customer voice |

---

## Context

Koru listens to the customer's voice on every single turn. The platform therefore holds, transiently, exactly the raw material a voice biometric system needs.

The temptation is obvious and it is the reason this record exists. If the customer is already speaking, matching that speech against an enrolled voiceprint appears to give a free authentication factor with zero friction. Several contact centre voice biometric deployments across the industry have been built on precisely that reasoning, and a number of banks have historically marketed a voiceprint as equivalent to a password.

That reasoning was defensible when synthesising a convincing human voice required a studio, a corpus of hours of clean audio and specialist skill.

It is not defensible now.

## The threat, stated plainly

| Factor | Position as at 2026 |
|---|---|
| Reference audio required to clone a voice | Seconds, not hours |
| Source of reference audio | Public social media, voicemail greetings, a recorded call, or a scam call placed specifically to harvest it |
| Cost to an attacker | Negligible. Commodity, widely available tooling |
| Skill required | Low |
| Quality achieved | Sufficient to defeat consumer-grade and many enterprise-grade speaker verification systems, including some liveness checks |
| Detection | An arms race that the defender does not reliably win, and the defender must win every time |

The asymmetry is what settles it. A voiceprint is a **public** biometric. Unlike a fingerprint or a face scan captured by a trusted sensor on a trusted device, a customer broadcasts their voice constantly, in public, to anyone. A credential that the customer cannot stop publishing is not a credential.

There is a second problem that is arguably worse. A voiceprint cannot be revoked. If a password leaks, the customer changes it. If a customer's voice is cloned, they cannot be issued a new one. Any system that treats a voiceprint as a factor is issuing a permanent, unrevocable, publicly harvestable credential.

## Decision

**Fern Bank will not use voice characteristics as an authentication factor, an authorisation factor, or a step-up factor, in Koru or anywhere else in the customer estate.**

Further, and specifically:

1. **All voice input is treated as untrusted input** throughout the pipeline, at the same trust level as text typed by an anonymous party on the public internet.
2. **No voiceprint is enrolled, computed, stored or compared.** Not for authentication, not "for fraud analytics", not "for future use". There is no enrolment path to be quietly repurposed later. This is control KORU-C-13.
3. **Authentication remains entirely with Fern ID**: passkeys and FIDO2 as the primary factor, with device binding, and explicit step-up challenges for sensitive actions.
4. **The media session is cryptographically bound to the already-authenticated web or app session.** The customer authenticates first, through the normal channel, and the voice session inherits that identity. Voice never establishes identity, it only operates within an identity already established. See FB-KORU-302.
5. **Saying something does not authorise it.** Any action above the Phase 1 read-only boundary requires an out-of-band, explicitly confirmed step-up in a channel that a voice clone cannot reach.

## Consequences

### Positive

- **KORU-R-05 drops from high inherent risk to low residual risk by design rather than by control.** There is no voice authentication attack surface because there is no voice authentication.
- The most likely attack against a voice banking channel, namely a synthesised customer voice requesting a payment, achieves nothing. The attacker still faces passkey authentication and step-up on a bound device.
- No biometric template database exists, which removes an extremely high value breach target and materially simplifies the privacy position under both Privacy Acts.
- The position is simple to explain to customers, to a regulator, and to a court. "We never accept your voice as proof of who you are" needs no caveats.
- It ages well. As synthesis improves, our position does not weaken.

### Negative

- **More friction than a voice-authenticated competitor.** A customer who has not authenticated must do so before Koru can discuss their accounts. Some customers will find this slower than a competitor that accepts a voiceprint.
- We forgo a marketing claim that some competitors make.
- Deaf, hard of hearing and speech-different customers gain nothing from this decision either way, but the friction lands on everyone.

We accept the friction. The alternative is to make the fraud problem someone else's, and eventually that someone is a customer.

### Neutral

- Voice is still used for **speech recognition**, which is a transcription function, not an identity function. The distinction is enforced architecturally: the speech service returns text, and no speaker embedding is requested, returned, computed or persisted.

## Alternatives considered

| Option | Assessment |
|---|---|
| **Voice as a primary factor** | Rejected outright. Indefensible in 2026. |
| **Voice as a secondary factor alongside a passkey** | Rejected. Adds no meaningful security beyond the passkey, and creates a template database, an enrolment flow and a customer expectation that all become liabilities. A weak factor added to a strong one mostly adds attack surface. |
| **Voice as a passive fraud signal only, never as a factor** | **Deferred, not rejected.** There is a legitimate argument for using speaker inconsistency as a risk signal that only ever *increases* friction and never decreases it. We have deferred this because it still requires computing and storing a speaker embedding, which is biometric information under both privacy regimes, and we are not willing to accept that data holding for a Phase 1 read-only capability. Revisit at Phase 3 with a full privacy assessment. |
| **Liveness and anti-spoofing detection to make voice safe again** | Rejected. This is an arms race where the defender must succeed on every attempt and the attacker needs to succeed once. We are not willing to bet customer funds on staying ahead of generative audio research. |

## What we do instead

| Need | Mechanism |
|---|---|
| Establish identity | Fern ID, passkey or FIDO2, device bound, before the media session opens |
| Maintain identity through the session | Media session cryptographically bound to the authenticated session token, with continuous access evaluation |
| Raise assurance for a sensitive action | Explicit step-up challenge on the bound device, out of the voice channel |
| Authorise a specific action | Fern Entitlements decision per tool call, independent of the conversation |
| Detect anomalous behaviour | Behavioural and transactional signals, device signals, and network signals. None of them biometric |
| Handle a suspected impersonation attempt | Immediate handoff to the Kaitiaki Desk with the full Ledger context |

## Compliance implications

| Obligation | Implication |
|---|---|
| Privacy Act 2020 (NZ) | No biometric information is collected, which removes a category of high-sensitivity personal information entirely. Strengthens the IPP 1 and IPP 5 positions. |
| Privacy Act 1988 (AU) | Voiceprints would be sensitive information under the Act, attracting heightened consent and handling obligations. Not collecting them avoids this entirely. |
| APRA CPS 234 | Removes a high-value information asset, namely a biometric template store, from the asset register and from the breach exposure. |
| ePayments Code and ASIC RG 271 | Reduces the risk of unauthorised transactions arising from a spoofable factor, and simplifies liability analysis in a dispute. |
| AML/CTF and AML/CFT | Customer identification and verification continue to rely on established, assessed methods. Koru introduces no new CIV pathway. |

## Reversibility

**One way door, by choice.** This position will be published in customer-facing security material and stated to both regulators. We would rather be held to it.

Any future proposal to introduce voice as a factor must return to the ARB as a new decision record superseding this one, accompanied by a fresh threat assessment, a privacy impact assessment, and Board-level acceptance of the residual fraud risk.

---

## Related documents

- [Identity and authentication](../../03-security/identity-and-authentication.md) (FB-KORU-302)
- [Threat model](../../03-security/threat-model.md) (FB-KORU-301)
- [Privacy impact assessment](../../04-compliance/privacy/privacy-impact-assessment.md) (FB-KORU-440)
- [ADR-0012 Mandatory AI disclosure](ADR-0012-mandatory-ai-disclosure.md)
