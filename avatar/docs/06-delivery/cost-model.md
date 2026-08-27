# Cost Model

**Document ID:** FB-KORU-601
**Version:** 1.0
**Date:** 27 August 2026
**Owner:** Finance Business Partner, Technology
**Status:** Submitted for review

**Related documents:** [Business case](../00-executive/business-case.md) (FB-KORU-011), [Roadmap](roadmap.md) (FB-KORU-600), [Cloud services catalogue](../02-architecture/cloud-services-catalogue.md) (FB-KORU-201)

All figures in New Zealand dollars unless stated. Australian costs are converted at 1.09 NZD per AUD for consolidated reporting.

---

## 1. Summary

| | Phase 0 (5 months) | Phase 1 (12 months) | Total to end of Phase 1 |
|---|---:|---:|---:|
| Build, internal | 2,940,000 | 2,380,000 | 5,320,000 |
| Build, partner and vendor | 1,160,000 | 1,020,000 | 2,180,000 |
| Cloud platform run | 600,000 | 2,900,000 | 3,500,000 |
| Kaitiaki Desk uplift | 0 | 1,800,000 | 1,800,000 |
| Assurance, model risk, legal | 700,000 | 900,000 | 1,600,000 |
| **Total** | **5,400,000** | **9,000,000** | **14,400,000** |

---

## 2. The cost that behaves differently

Most technology programmes have a large build cost and a modest, predictable run cost. Koru does not.

**The run cost is variable, per-conversation, and grows linearly with success.** Every turn costs money in a way a database query does not: speech recognition per second of audio, model inference per token, avatar synthesis per second of generated video, safety evaluation per turn.

This has three consequences that the Board should hold onto:

1. **Cost control is an engineering discipline, not a procurement one.** A 15 percent reduction in average tokens per turn is worth more than any discount we will negotiate.
2. **Cost is an attack surface.** Denial of wallet is a real threat, catalogued in the threat model. An attacker who cannot breach us can still make us expensive.
3. **Cost scales before benefit does.** Every conversation costs on turn one. The benefit accrues over the customer's lifetime.

---

## 3. Cloud run cost, decomposed

### 3.1 Unit costs per conversational turn

Modelled at steady-state Phase 1 volumes. A turn is one customer utterance and one Koru response.

| Component | Driver | Unit assumption | Cost per turn |
|---|---|---|---:|
| Speech to text, streaming | Seconds of customer audio | 7.5 seconds average | 0.0043 |
| Model inference, fast conversational model | Input plus output tokens | 2,400 in, 180 out | 0.0091 |
| Model inference, reasoning model | Applies to 12 percent of turns | 3,100 in, 260 out | 0.0067 |
| Classifier and routing model | Every turn | 900 in, 20 out | 0.0006 |
| Embedding generation | Every retrieval turn, 78 percent | 60 tokens | 0.0001 |
| Retrieval, Azure AI Search | Query units | Hybrid plus semantic ranking | 0.0022 |
| Content safety and groundedness | Every turn, both directions | 4 evaluations | 0.0038 |
| **Avatar synthesis** | **Seconds of generated video** | **9.2 seconds average** | **0.0412** |
| Media relay and egress | Minutes of WebRTC | Shared across turn | 0.0074 |
| Ledger write, storage and ingestion | Per record | ~14 KB | 0.0009 |
| Compute, Container Apps | Amortised per turn | | 0.0031 |
| Data platform, Cosmos and Redis | Amortised per turn | | 0.0018 |
| **Total per turn** | | | **0.0812** |

**Avatar synthesis is 51 percent of the marginal cost per turn.** This is the single most important number in the cost model, and it validates the concern raised in ADR-0002.

### 3.2 Cost per session

| Measure | Value |
|---|---:|
| Average turns per session | 4.3 |
| Marginal cost per session | 0.349 |
| Allocated fixed platform cost per session | 0.031 |
| **Fully loaded cost per contained session** | **0.380** |

Against a blended assisted-channel cost to serve of **6.10**, a contained session avoids approximately **5.72** of variable handling cost.

### 3.3 Fixed platform cost

Costs incurred whether or not a customer talks to Koru. Duplicated across two sovereign deployments per ADR-0003.

| Component | Monthly, per deployment | Note |
|---|---:|---|
| Container Apps, dedicated workload profiles, minimum replicas | 11,400 | Minimum replicas above zero is a deliberate latency choice, ADR-0010 |
| Azure AI Search, standard tier with replicas | 6,800 | |
| Cosmos DB, provisioned with autoscale | 5,200 | |
| Azure Cache for Redis, Premium zone redundant | 3,900 | |
| API Management Premium, VNet injected | 8,700 | Premium is required for VNet injection and zone redundancy |
| Azure Data Explorer, Ledger analytics | 7,300 | |
| Front Door Premium and WAF | 2,100 | |
| Azure Firewall Premium | 4,600 | |
| Log Analytics and Application Insights | 5,400 | Volume driven, grows with traffic |
| Key Vault Managed HSM | 4,300 | Required for customer managed keys at the assurance level we claim |
| Storage, immutable Ledger archive | 1,900 | Grows over the 7 year retention |
| Defender for Cloud, Purview | 2,600 | |
| Non-production environments | 9,200 | Single instance, not duplicated |
| **Per deployment monthly** | **~64,200** | |
| **Two deployments plus shared non-prod** | **~137,600** | |

Annualised fixed platform cost: approximately **1,651,000**.

**The duplication cost of sovereignty (ADR-0003) is approximately 640,000 per year.** We state this explicitly because the Board is entitled to see the price of that decision. Our position is that it buys a defensible regulatory posture and a clean answer to customers, and that it is worth it. But it is not free and we do not pretend it is.

### 3.4 Phase 1 variable cost build-up

| Cohort step | Sessions per month | Variable cost per month |
|---|---:|---:|
| 1.0 Closed beta, 0.5 percent | 12,000 | 4,190 |
| 1.1 Limited, 1 percent | 24,000 | 8,380 |
| 1.2 Expanded, 2.5 percent | 61,000 | 21,290 |
| 1.3 Target, 5 percent | 122,000 | 42,580 |

Phase 1 twelve-month total, blending the ramp: fixed **1,651,000** plus variable **~404,000** plus non-production and contingency, giving the **2,900,000** cloud run line.

---

## 4. Cost control levers

Ranked by impact. These are engineering commitments, not aspirations, and each has a named owner in the Phase 0 plan.

| # | Lever | Mechanism | Estimated saving | Risk |
|---|---|---|---:|---|
| 1 | **Audio-first default for eligible sessions** | Offer audio-only where the customer's context suggests it, and make it a one-tap preference | Up to 40 percent of marginal cost | Reduces the experience benefit that justified the avatar |
| 2 | **Trim avatar synthesis duration** | Shorter, tighter responses. Every second of speech is 0.0045 | 8 to 12 percent | Terseness can read as unhelpful |
| 3 | **Aggressive context minimisation** | Send only the retrieved chunks needed, not the whole retrieval set. Summarise conversation history beyond 6 turns | 10 to 15 percent | Risk of losing context that mattered |
| 4 | **Model routing discipline** | Keep the reasoning model at or below 12 percent of turns. Every point above costs approximately 0.00056 per turn | 5 to 8 percent | Under-routing degrades quality on complex turns |
| 5 | **Semantic response caching** | Cache grounded responses for high-frequency, non-personalised questions, keyed on intent plus corpus version | 6 to 9 percent | **Must never cache anything containing customer data.** Control KORU-C-26 |
| 6 | **Prompt compression** | Shorter system prompts, externalised policy | 4 to 6 percent | Prompt changes require re-evaluation |
| 7 | **Reserved capacity and commitments** | Provisioned throughput once volume is predictable | 15 to 25 percent on committed components | Reduces flexibility, increases switching cost against ADR-0009 |

Lever 5 carries a specific warning. Caching is the most attractive lever on the list and the most dangerous. A caching bug that returns one customer's grounded answer to another customer is a privacy incident. The cache key must be provably free of customer identifiers, and this is tested in CI.

---

## 5. Cost as a risk

### 5.1 Denial of wallet

An attacker who cannot compromise Koru can still make it expensive by generating long, complex, reasoning-model-routed conversations at scale.

| Control | Detail | Control ID |
|---|---|---|
| Per-session token budget | Hard cap. Session ends gracefully with an offer of a human | KORU-C-41 |
| Per-customer daily budget | Rolling. Exceeding it degrades to text-only, then to refusal | KORU-C-41 |
| Per-tenant hourly spend cap | Circuit breaker halts new sessions and pages on-call | KORU-C-42 |
| Anomaly detection on cost per session | Alert at 3 standard deviations from baseline | KORU-C-64 |
| Authenticated access only | Phase 1 requires an authenticated customer, which bounds the attacker population substantially | KORU-C-11 |

### 5.2 Cost anomaly response

A sustained cost anomaly is treated as a **potential security incident first and a finance issue second**, because the most likely causes are abuse, a prompt regression causing runaway context growth, or a retry storm. The runbook procedure is in FB-KORU-504.

---

## 6. Sensitivity analysis

Phase 1 twelve-month total cost under varying assumptions.

| Scenario | Sessions per month at target | Avatar share of sessions | Turns per session | Cloud run cost | Total Phase 1 |
|---|---:|---:|---:|---:|---:|
| **Pessimistic** | 160,000 | 95 percent | 6.1 | 3,760,000 | 10,100,000 |
| **Base** | 122,000 | 85 percent | 4.3 | 2,900,000 | 9,000,000 |
| **Optimistic** | 122,000 | 60 percent | 3.6 | 2,290,000 | 8,300,000 |
| **Volume upside** | 240,000 | 85 percent | 4.3 | 4,180,000 | 10,600,000 |

The volume upside row is instructive. Doubling successful usage increases total Phase 1 cost by only 18 percent, because the fixed platform cost dominates at these volumes. **The economics improve materially with scale**, which is the argument for proceeding past Phase 1 if the evidence supports it.

The pessimistic scenario is driven by turns per session rising to 6.1, which would indicate Koru is failing to resolve efficiently. In that scenario the cost problem is a symptom, not the disease.

---

## 7. What is not in this model

Stated so the Board is not surprised later.

| Excluded | Why | Estimated if included |
|---|---|---|
| Phase 2, 3 and 4 costs | Not approved and not scoped | Not estimated |
| A second warm model provider (ADR-0009 deferred option) | Deferred pending the Board's KORU-R-03 position | Approximately 780,000 per year |
| Fern Core API uplift | Funded separately under the core banking programme | Approximately 400,000 |
| Fern ID passkey rollout | Funded separately under the identity programme | Approximately 1,200,000 |
| Contact centre transformation beyond the Kaitiaki Desk uplift | Out of scope | Not estimated |
| Marketing and customer communications | Held by Personal Banking | Approximately 350,000 |
| Benefit realisation | Covered in FB-KORU-011 | |

---

## 8. Cost governance

| Control | Cadence | Owner |
|---|---|---|
| Cost per session and cost per turn reported against model | Weekly | Head of Platform Engineering |
| Cloud spend against budget, by component | Monthly | Finance Business Partner |
| Cost anomaly alerts | Real time | SRE on-call |
| Cost efficiency lever progress | Monthly, into the assurance report | Head of AI Engineering |
| Full model refresh | Quarterly | Finance Business Partner |
| Reserved capacity decision | At Phase 1 steady state | Head of Infrastructure |

Cost per contained session is reported in the monthly assurance report to the Technology and Operational Risk Committee (ARB condition C8), alongside the quality and conduct metrics, so that efficiency is never reviewed in isolation from outcomes.

---

## 9. Reality disclaimer

Fern Bank is fictional and all figures are constructed for this exercise. Unit costs are illustrative and do not reflect any vendor's actual pricing. Real cost modelling must be built from current published pricing and negotiated commercial terms. See the [programme canon](../programme-canon.md#9-reality-disclaimer).
