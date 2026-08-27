# Architecture Decision Records

**Document ID:** FB-KORU-210
**Version:** 1.0
**Date:** 27 August 2026
**Owner:** Chief Architect, Digital Channels
**Status:** Submitted for review

---

## Purpose

An ARB is best served by seeing the decisions that were genuinely contested, not a tidy narrative written after the fact. This set records fourteen decisions for Project Koru. Each includes the option we rejected and what it would cost us to reverse course.

Where a decision was close, we say so. Where a decision was unanimous, we say that too, because unanimity is itself information.

## Format

Each record follows a consistent structure: Status, Context, Decision, Consequences (positive, negative, neutral), Alternatives considered, Compliance implications, and Reversibility.

**Reversibility** is scored as:

| Score | Meaning |
|---|---|
| **Easy** | Days to weeks. Configuration or contained code change. |
| **Moderate** | One to two quarters. Requires redesign of a component but not the platform. |
| **Hard** | Multi-quarter. Requires re-architecture, re-approval, or renegotiation. |
| **One way door** | Practically irreversible once customer traffic depends on it. |

We pay disproportionate attention to one way doors. There are three in this set: ADR-0003, ADR-0004 and ADR-0013.

---

## The decisions

| ADR | Decision | Status | Contested | Reversibility |
|---|---|---|---|---|
| [0001](ADR-0001-azure-as-ai-platform.md) | Microsoft Azure as the AI and hosting platform | Accepted | Yes | Hard |
| [0002](ADR-0002-cloud-rendered-avatar.md) | Cloud-rendered avatar over on-device 3D rendering | Accepted | Yes | Moderate |
| [0003](ADR-0003-jurisdictional-isolation.md) | Two sovereign deployments, no cross-Tasman data movement | Accepted | No | One way door |
| [0004](ADR-0004-no-voice-biometric-authentication.md) | Voice is never an authentication factor | Accepted | No | One way door |
| [0005](ADR-0005-read-only-first.md) | Read-only capability before any write capability | Accepted | Yes | Easy |
| [0006](ADR-0006-assurance-plane-as-a-service.md) | The Assurance Plane is a separate service, not a library | Accepted | Yes | Moderate |
| [0007](ADR-0007-grounded-response-only.md) | Grounded or silent. No un-grounded substantive answers | Accepted | No | Easy |
| [0008](ADR-0008-no-customer-data-in-training.md) | Customer data is never used to train or fine-tune models | Accepted | No | Hard |
| [0009](ADR-0009-model-portability.md) | Abstract the model interface to preserve portability | Accepted | Yes | Moderate |
| [0010](ADR-0010-container-apps-over-aks.md) | Azure Container Apps rather than Azure Kubernetes Service | Accepted | Yes | Moderate |
| [0011](ADR-0011-no-personal-advice.md) | Koru does not give personal financial advice | Accepted | No | Easy |
| [0012](ADR-0012-mandatory-ai-disclosure.md) | Mandatory, repeated disclosure that Koru is not human | Accepted | No | Easy |
| [0013](ADR-0013-immutable-interaction-ledger.md) | Every interaction is recorded immutably and is replayable | Accepted | Yes | One way door |
| [0014](ADR-0014-human-handoff-always-available.md) | A human is always reachable, and Koru always offers one | Accepted | No | Easy |

---

## Decisions deferred

These are known, live questions that we have consciously not answered yet. Deferring a decision is a decision, and the ARB should see them.

| Question | Why deferred | Decide by |
|---|---|---|
| Whether Phase 3 value movement uses signed intent tokens or a separate confirmation channel | Depends on Phase 1 evidence about customer comprehension of spoken confirmations | Phase 2 exit |
| Whether to offer Koru to business banking customers | Different entitlement model, different conduct obligations, and no Phase 1 evidence | Q3 2027 |
| Whether the avatar likeness is synthetic-generic or a licensed presenter | Legal, brand and cultural review incomplete, and a licensed likeness creates long term dependency | Phase 0 exit |
| Whether to run a secondary model provider in active-active | Depends on measured concentration risk appetite after the Board response to KORU-R-03 | Phase 1 exit |

---

## Superseded decisions

None yet. When a decision is superseded, the original record stays in place with its status changed and a forward link. We do not delete history.

---

## Related documents

- [Solution architecture](../solution-architecture.md) (FB-KORU-200)
- [ARB submission](../../../ARB-SUBMISSION.md) (FB-KORU-001)
- [Programme canon](../../programme-canon.md) (FB-KORU-000)
