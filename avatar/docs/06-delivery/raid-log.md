# RAID Log

**Document ID:** FB-KORU-602
**Version:** 1.0
**Date:** 27 August 2026
**Owner:** Programme Director, Project Koru
**Status:** Live. Reviewed fortnightly at Koru steering group.

**Related documents:** [ARB submission](../../ARB-SUBMISSION.md) (FB-KORU-001), [Roadmap](roadmap.md) (FB-KORU-600), [Threat model](../03-security/threat-model.md) (FB-KORU-301), [Control matrix](../04-compliance/control-matrix.md) (FB-KORU-401)

---

## How to read this

A RAID log that contains only manageable risks is a marketing document. This one contains the things that genuinely worry the people building Koru, including two entries the Board may find uncomfortable.

**Scoring.** Likelihood and impact are scored 1 to 5. Rating is the product, banded as Low (1 to 6), Medium (8 to 12), High (15 to 16), Critical (20 to 25).

---

## 1. Risks

### 1.1 Register

| ID | Risk | Cat | Inh L | Inh I | Inherent | Res L | Res I | **Residual** | Owner |
|---|---|---|---:|---:|---|---:|---:|---|---|
| KORU-R-01 | Koru gives a confidently incorrect answer on fees, rates or terms | Conduct | 4 | 4 | **16 High** | 2 | 4 | **8 Medium** | Head of Model Risk |
| KORU-R-02 | Prompt injection causes policy bypass or unintended tool use | Security | 4 | 4 | **16 High** | 2 | 4 | **8 Medium** | CISO |
| KORU-R-03 | Concentration on a single AI platform provider | Operational | 3 | 5 | **15 High** | 3 | 5 | **15 High** | CTO |
| KORU-R-04 | Vulnerable customer harmed by an efficient but unempathetic interaction | Conduct | 4 | 4 | **16 High** | 2 | 4 | **8 Medium** | Head of Customer Experience |
| KORU-R-05 | Deepfaked customer voice used to socially engineer the channel | Fraud | 5 | 4 | **20 Critical** | 1 | 3 | **3 Low** | Head of Fraud |
| KORU-R-06 | Customer believes Koru is a human being | Conduct | 4 | 3 | **12 Medium** | 2 | 2 | **4 Low** | Head of Customer Experience |
| KORU-R-07 | Latency makes the experience worse than the channel it replaces | Delivery | 3 | 4 | **12 Medium** | 3 | 3 | **9 Medium** | Head of Platform Engineering |
| KORU-R-08 | Retrieval corpus decays and Koru quotes withdrawn or superseded content | Conduct | 4 | 3 | **12 Medium** | 2 | 3 | **6 Low** | Head of Product Content |
| KORU-R-09 | Escalation rate materially exceeds the 18 to 25 percent model | Financial | 3 | 3 | **9 Medium** | 3 | 3 | **9 Medium** | Head of Contact Centre |
| KORU-R-10 | Azure New Zealand North lacks required AI or speech capacity | Delivery | 3 | 5 | **15 High** | 2 | 5 | **10 Medium** | Head of Infrastructure |
| KORU-R-11 | Product content owners not released from BAU, corpus slips | Delivery | 4 | 4 | **16 High** | 3 | 4 | **12 Medium** | GM Personal Banking |
| KORU-R-12 | Model deprecated or materially changed by the vendor mid-phase | Operational | 4 | 3 | **12 Medium** | 3 | 2 | **6 Low** | Head of AI Engineering |
| KORU-R-13 | Speech recognition performs materially worse for some accents or speech differences | Conduct | 4 | 4 | **16 High** | 3 | 3 | **9 Medium** | Head of Customer Experience |
| KORU-R-14 | Cost runaway through abuse or a prompt regression | Financial | 3 | 3 | **9 Medium** | 2 | 2 | **4 Low** | Head of Platform Engineering |
| KORU-R-15 | Regulator objects to the capability or requires changes late | Regulatory | 2 | 5 | **10 Medium** | 1 | 4 | **4 Low** | Head of Compliance |
| KORU-R-16 | Advice boundary classifier fails, producing an unlicensed recommendation | Regulatory | 3 | 5 | **15 High** | 2 | 4 | **8 Medium** | General Counsel |
| KORU-R-17 | Ledger becomes a target, or its existence creates a privacy harm | Privacy | 2 | 5 | **10 Medium** | 1 | 5 | **5 Low** | Chief Privacy Officer |
| KORU-R-18 | Customers substitute Koru for human contact in a way that harms them | Conduct | 3 | 4 | **12 Medium** | 3 | 3 | **9 Medium** | Head of Customer Experience |
| KORU-R-19 | Evaluation harness fails to detect a novel failure class | Model risk | 4 | 4 | **16 High** | 3 | 4 | **12 Medium** | Head of Model Risk |
| KORU-R-20 | Brand or cultural harm through inappropriate use of the koru form | Reputational | 3 | 4 | **12 Medium** | 1 | 4 | **4 Low** | Head of Customer Experience |

### 1.2 The three residual risks that are not comfortable

Most entries above reduce to Medium or Low. Three do not, and they are the ones the Board should spend time on.

---

#### KORU-R-03. Concentration on a single AI platform provider
**Inherent High 15. Residual High 15. Unchanged.**

We have not reduced this risk. We have understood it, bounded its consequences and made the exit costed and tested, but the likelihood and impact of a severe, prolonged provider impairment are not materially different because of anything we did.

| Treatment | Effect |
|---|---|
| Registered material service provider, contract uplifted with step-in rights (ADR-0001) | Improves our position in a failure, does not prevent one |
| Model abstraction layer (ADR-0009) | Makes model substitution cheap. Does not help with avatar synthesis |
| Tested descent to non-generative fallback (FB-KORU-503) | **Bounds the consequence.** Customers are still served, in a degraded way |
| Koru is not a critical operation (ADR-0005) | **Bounds the consequence.** Basic banking is unaffected |
| Deferred option: second warm provider | Would reduce likelihood. Costs approximately 780,000 per year |

**Requested Board action:** formal acceptance of this residual risk, or direction to fund the second provider option.

---

#### KORU-R-18. Customers substitute Koru for human contact in a way that harms them
**Inherent Medium 12. Residual Medium 9.**

This is the risk with the weakest treatment in the register, and we want to be honest that our controls are partial.

An avatar that is warm, always available, endlessly patient and never rushed will be preferred by some customers over a human, including customers for whom human contact was the actual value of the interaction. An isolated older customer who called the contact centre partly to talk to somebody may now talk to Koru instead, and Koru will be more available, more patient, and worse for them.

| Treatment | Honest assessment |
|---|---|
| Mandatory AI disclosure (ADR-0012) | Necessary. Does not address a customer who knows and prefers it anyway |
| Drift detection and proactive human offer | Helps. Detects some cases |
| Kaitiaki Desk always available (ADR-0014) | Removes the barrier. Does not create the pull |
| Vulnerability protocol | Catches acute distress, not chronic isolation |
| **Planned:** longitudinal outcome research with the Phase 1 cohort | The only treatment that will actually tell us the size of this problem |

**We do not have a good answer to this risk.** We have flagged it in the README, in the ARB submission and here, because a Board that is not told about it cannot weigh it. We would welcome challenge on whether Phase 1 should proceed without a stronger treatment.

---

#### KORU-R-19. The evaluation harness fails to detect a novel failure class
**Inherent High 16. Residual Medium 12.**

Our harness tests for failures we thought of. Every serious AI incident in the industry has involved a failure someone did not think of.

| Treatment | Effect |
|---|---|
| Regression suites, golden datasets, CI gating | Catches known classes reliably |
| Continuous red teaming | Catches classes an adversary thinks of |
| Online sampling with human review | Catches classes that occur in production, after they occur |
| Grounded-only responses (ADR-0007) | Narrows the space of possible outputs substantially |
| Assurance Plane evaluates output independently of the model (ADR-0006) | Catches some novel classes because the check does not share the model's blind spots |
| Read-only phase (ADR-0005) | **Bounds the consequence.** A novel failure in Phase 1 misinforms, it does not transact |

The last row is the real treatment. We cannot guarantee we will catch every novel failure. We can guarantee that when one occurs in Phase 1, nobody's money moved.

---

### 1.3 Selected treatment detail

| ID | Key treatments | Control IDs | Evidence |
|---|---|---|---|
| KORU-R-01 | Grounded-only responses, groundedness >= 0.95, citation binding, numeric verification, corpus currency, refusal thresholds, continuous evaluation | C-30, C-32, C-34, C-35 | ADR-0007, FB-KORU-202 |
| KORU-R-02 | Prompt shields, indirect injection defence on retrieved content, tool allow-listing, output policy independent of model, no egress from Reasoning Plane, three-layer write prevention | C-30, C-36, C-37, C-16 | ADR-0005, ADR-0006, FB-KORU-301 |
| KORU-R-04 | Distress signal detection, mandatory human offer, no-pressure design, Kaitiaki Desk specialist training, protocol review of 100 percent of invocations | C-70, C-72, C-74 | FB-KORU-102, ADR-0014 |
| KORU-R-05 | Voice is never an authentication factor. No voiceprint enrolled or stored. All authorisation via Fern ID and step-up | C-13, C-11 | ADR-0004, FB-KORU-302 |
| KORU-R-08 | Corpus entries carry owner, version and validity window. Expired content is not retrievable. Refusal on empty retrieval. Corpus health dashboard and monthly owner attestation | C-27, C-35 | FB-KORU-203 |
| KORU-R-13 | Accent and speech-difference performance testing by cohort, published thresholds, automatic text fallback offer on repeated low confidence, community testing with paid participants | C-73 | FB-KORU-103 |
| KORU-R-16 | Advice classifier inbound and outbound, deliberately over-sensitive, distress protocol takes precedence, external legal opinion before Phase 1 | C-75, C-76 | ADR-0011 |
| KORU-R-20 | Te Ao Māori engagement with iwi and cultural advisors, gating condition on brand launch, cultural advisor veto on visual identity | C-77 | FB-KORU-103 |

---

## 2. Assumptions

| ID | Assumption | Impact if wrong | Owner | Resolve by | Status |
|---|---|---|---|---|---|
| KORU-A-01 | p95 latency of 1.2 seconds to first audible word is achievable on mid-range Android devices on regional New Zealand mobile networks | Experience thesis weakens materially. Likely descent to Option B text-only | Head of Platform Engineering | 30 Nov 2026, field test | **Open, highest priority** |
| KORU-A-02 | 18 to 25 percent of Phase 1 sessions escalate to a human | Kaitiaki Desk staffing and business case both need rebuilding | Head of Contact Centre | 31 Mar 2027, closed beta data | Open |
| KORU-A-03 | The Assurance Plane adds approximately 90ms per direction | Latency budget breaks. May force the sidecar option, weakening control evidence | Head of Platform Engineering | Phase 0 exit | Open |
| KORU-A-04 | Azure New Zealand North has the required AI model and speech capacity | NZ deployment deferred. See KORU-R-10 | Head of Infrastructure | 31 Oct 2026 | **Open** |
| KORU-A-05 | The advice boundary position holds under external legal review in both jurisdictions | Phase 1 scope narrows significantly | General Counsel | 30 Nov 2026 | Open |
| KORU-A-06 | Fern Core read APIs can respond within the 220ms allocated in the latency budget | Latency budget breaks | Head of Core Banking | 30 Nov 2026 | Open |
| KORU-A-07 | Synthetic evaluation data adequately represents real customer language, including distressed and confused speech | Evaluation gives false confidence. Directly worsens KORU-R-19 | Head of Model Risk | Phase 1 closed beta | **Open, uncomfortable** |
| KORU-A-08 | Customers will accept a 6 second disclosure preamble at session start | Session abandonment higher than modelled | Head of Customer Experience | Closed beta | Open |
| KORU-A-09 | Four full-time product content owners is sufficient to build and maintain the corpus | Corpus gaps become customer-visible refusals. See KORU-R-11 | Head of Product Content | Phase 0 exit | Open |
| KORU-A-10 | Vendor model pricing remains within 20 percent of current levels through Phase 1 | Cost model breaks. See FB-KORU-601 sensitivity | Head of Procurement | Ongoing | Open |
| KORU-A-11 | The narrow aggregated-metrics exception in ADR-0003 remains genuinely non-re-identifiable at scale | Sovereignty position weakens | Chief Privacy Officer | Phase 0 exit | Open |

**KORU-A-07 deserves a note.** We are building evaluation data synthetically because ADR-0008 forbids using real customer conversations. That is the right privacy decision and it creates a real evaluation weakness. We are not going to reverse ADR-0008 to fix it. We will instead invest in structured research with consenting participants to make the synthetic data better, and we will treat the residual gap as a known limitation rather than pretending it does not exist.

---

## 3. Issues

Live issues requiring resolution. An issue is a risk that has occurred.

| ID | Issue | Raised | Impact | Owner | Target | Status |
|---|---|---|---|---|---|---|
| KORU-I-01 | Product content owners not yet formally released from BAU. Corpus workstream W5 is on the critical path and is currently under-resourced by 2.5 FTE | 5 Aug 2026 | **Critical path slip of 3 to 5 weeks if unresolved by mid-September** | GM Personal Banking | 15 Sep 2026 | **Open, escalated to steering** |
| KORU-I-02 | Microsoft contract uplift to CPS 230 minimum content is in negotiation. Step-in rights and fourth-party disclosure clauses are unresolved | 22 Jul 2026 | Blocks Phase 1 entry, ARB condition C4 | Head of Procurement | 20 Dec 2026 | Open, on track |
| KORU-I-03 | Fern Core read API p95 currently measures 340ms against the 220ms allocation | 14 Aug 2026 | Consumes 120ms of latency headroom. Threatens KORU-A-01 | Head of Core Banking | 30 Nov 2026 | Open, remediation planned |
| KORU-I-04 | Independent red team vendor procurement not yet complete | 1 Aug 2026 | Blocks Phase 0 exit, ARB condition C2 | CISO | 15 Nov 2026 | Open, on track |
| KORU-I-05 | Accessibility community testing participants not yet recruited for te reo Māori and Pasifika accent cohorts | 18 Aug 2026 | Weakens KORU-R-13 treatment and FB-KORU-103 evidence | Head of Customer Experience | 31 Oct 2026 | Open |
| KORU-I-06 | No agreed definition of "materially incorrect" for measuring KORU-R-01 in production. Evaluation uses a Phase 0 definition that will not survive contact with real complaints | 25 Aug 2026 | Undermines the Phase 2 evidence base | Head of Model Risk | 30 Nov 2026 | Open |

**KORU-I-01 is the most urgent item in this log.** It is not technically difficult, it is an organisational release of four people, and it sits directly on the critical path. It is the sort of issue programmes lose months to while discussing architecture.

---

## 4. Dependencies

Cross-referenced to [FB-KORU-600 section 5](roadmap.md#5-dependencies).

| ID | Dependency | Provider | Needed by | Criticality | Status |
|---|---|---|---|---|---|
| D1 | Azure New Zealand North AI and speech capacity | Microsoft | Oct 2026 | **Critical** | Open |
| D2 | Microsoft contract uplift, CPS 230 | Microsoft, Procurement | Dec 2026 | **Critical** | In progress |
| D3 | Fern Core read API performance | Core Banking programme | Nov 2026 | High | In progress |
| D4 | Fern ID passkey rollout coverage | Identity programme | Jan 2027 | Medium | On track |
| D5 | Product content owners released | Personal Banking | Sep 2026 | **Critical** | **Open, see KORU-I-01** |
| D6 | Kaitiaki Desk recruitment, 14 FTE | Contact Centre | Dec 2026 | High | In progress |
| D7 | External legal opinion, advice boundary | External counsel | Nov 2026 | High | In progress |
| D8 | Te Ao Māori cultural engagement concluded | Cultural advisors, iwi partners | Dec 2026 | High | In progress |
| D9 | Independent red team vendor | CISO, Procurement | Nov 2026 | High | Open |
| D10 | Azure Policy landing zone changes for jurisdiction locking | Cloud Platform team | Oct 2026 | Medium | On track |

---

## 5. Review and escalation

| Item | Reviewed | Escalation trigger | Escalates to |
|---|---|---|---|
| Full RAID log | Fortnightly, Koru steering group | | |
| High and Critical residual risks | Monthly, Technology and Operational Risk Committee | Any new High residual | Board Risk Committee |
| KORU-R-03 | Quarterly | Any change to treatment or appetite | Board Risk Committee |
| Critical dependencies | Weekly | Any slip beyond 2 weeks | Programme Director then CTO |
| Issues | Weekly | Any issue open beyond target date | Steering group |
| Assumptions | At each gate | Any assumption proven false | ARB if it affects a design decision |

---

## 6. Reality disclaimer

Fern Bank is a fictional institution. This log is illustrative, exercise-grade material for architecture review practice. Risks, issues, dates and owners are constructed for the exercise. See the [programme canon](../programme-canon.md#9-reality-disclaimer).
