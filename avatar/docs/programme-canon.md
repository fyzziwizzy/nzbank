# Programme Canon

**Document ID:** FB-KORU-000
**Version:** 1.0
**Date:** 27 August 2026
**Owner:** Fern Bank Enterprise Architecture
**Status:** Controlled. Every artefact in this repository conforms to this canon.

This file is the single source of truth for names, identifiers, regions and drafting conventions used across the Project Koru submission. If any document disagrees with this file, this file wins.

---

## 1. The programme

| Field | Value |
|---|---|
| Programme name | **Project Koru** |
| Product name | **Koru**, the Fern Bank personal banking avatar |
| Sponsor | Chief Executive, Personal Banking |
| Accountable executive | Chief Technology Officer |
| Delivery owner | General Manager, Digital Channels |
| Submitting body | Fern Bank Enterprise Architecture |
| Receiving body | Fern Bank Architecture Review Board (ARB) |
| Proposed ARB date | 10 September 2026 |
| Document set version | 1.0 |

### Why "Koru"

The koru is the unfurling frond of the silver fern. It signals new growth, renewal and forward movement while staying anchored to its origin. It is the natural expression of the Fern Bank brand and the intent of the product: help a customer take the next step with their money without losing sight of where they stand today.

Cultural use of the koru form carries obligations. See `docs/01-experience/accessibility-and-inclusion.md` for the Te Ao Māori engagement position, which is a gating condition on brand launch, not an afterthought.

---

## 2. The entities

| Entity | Jurisdiction | Regulator | Notes |
|---|---|---|---|
| Fern Bank Limited | New Zealand | Reserve Bank of New Zealand (RBNZ), Financial Markets Authority (FMA) | Registered bank |
| Fern Bank Australia Limited | Australia | Australian Prudential Regulation Authority (APRA), ASIC | Authorised deposit-taking institution (ADI) |

Both entities are in scope. The architecture is one logical platform with two sovereign deployments. Customer data does not cross the Tasman.

---

## 3. Platform naming

| Component | Canonical name | Description |
|---|---|---|
| Avatar experience | **Koru** | What the customer sees and speaks to |
| Session orchestration | **Koru Orchestrator** | Turn taking, media, barge-in, session state |
| Reasoning layer | **Koru Reasoning Plane** | Model routing, tool calling, planning |
| Grounding layer | **Koru Knowledge Plane** | Retrieval, citations, product truth |
| Guardrail layer | **Koru Assurance Plane** | Safety, policy, disclosure, evaluation |
| Interaction ledger | **Koru Ledger** | Immutable, replayable record of every interaction |
| Core banking | **Fern Core** | System of record for accounts, payments, cards |
| Customer identity | **Fern ID** | Customer identity and access management |
| Entitlements service | **Fern Entitlements** | Authorisation decisions for every action |
| Human handoff | **Kaitiaki Desk** | Specialist humans who receive escalations |

`Kaitiaki` means guardian or steward. The naming is deliberate: the humans are not a fallback for a broken robot, they are the guardians of the customer relationship.

---

## 4. Azure regions and residency

| Deployment | Primary region | Secondary region | Data residency rule |
|---|---|---|---|
| `prod-nz` | New Zealand North | New Zealand North availability zones | New Zealand customer data remains in New Zealand |
| `prod-au` | Australia East | Australia Southeast | Australian customer data remains in Australia |
| `dev` / `test` | Australia East | Not applicable | Synthetic data only. No production customer data, ever |

**Hard rule.** There is no cross-Tasman replication of customer content, prompts, transcripts, embeddings or model telemetry. Failover is zone-based within jurisdiction, not region-based across jurisdictions. This constraint drives the topology in `docs/02-architecture/network-and-connectivity.md` and is tested under `docs/05-operations/business-continuity.md`.

---

## 5. Environment and resource naming

Pattern: `<org>-<programme>-<component>-<env>-<region>-<instance>`

- `org` = `fb`
- `programme` = `koru`
- `env` = `dev` | `test` | `prd`
- `region` = `aue` (Australia East), `aus` (Australia Southeast), `nzn` (New Zealand North)

Examples:

```
fb-koru-orchestrator-prd-nzn-001
fb-koru-search-prd-aue-001
fb-koru-kv-prd-nzn-001
```

Storage accounts and other globally unique, alphanumeric-only resources drop the hyphens: `fbkoruledgerprdnzn001`.

---

## 6. Document identifiers

| Range | Domain |
|---|---|
| FB-KORU-0xx | Programme and executive |
| FB-KORU-1xx | Experience and customer journey |
| FB-KORU-2xx | Architecture |
| FB-KORU-3xx | Security |
| FB-KORU-4xx | Compliance and regulatory |
| FB-KORU-5xx | Operations |
| FB-KORU-6xx | Delivery |
| ADR-00xx | Architecture decision records |
| KORU-R-xx | Risks |
| KORU-C-xx | Controls |

---

## 7. Delivery phases

| Phase | Name | Capability | Target |
|---|---|---|---|
| Phase 0 | **Foundations** | Platform, guardrails, evaluation harness, no customer traffic | Q4 2026 |
| Phase 1 | **Koru Informs** | Read-only. Balances, transactions, product explanation, fee and rate questions | Q1 2027 |
| Phase 2 | **Koru Assists** | Low-risk servicing. Card freeze, dispute lodgement, limit views, statement requests | Q3 2027 |
| Phase 3 | **Koru Acts** | Value-moving actions inside strict limits, with step-up authentication and signed intent | Q1 2028 |
| Phase 4 | **Koru Advises** | Guided budgeting and goal coaching, subject to a separate advice licensing assessment | Not before 2029 |

Each phase is a separate ARB gate. Approval of Phase 1 does not imply approval of Phase 2.

---

## 8. Drafting conventions

These are enforceable style rules for this repository.

1. **No em-dashes.** Use full stops, commas, "and", "to" or a colon.
2. **New Zealand English.** organisation, realise, centre, programme, licence (noun), authorise.
3. Every document opens with a metadata block: Document ID, Version, Date, Owner, Status.
4. Every control claim carries a control ID from `docs/04-compliance/control-matrix.md`.
5. Every regulatory claim names the instrument and the clause or section it addresses.
6. Diagrams are Mermaid in Markdown. No binary image dependencies.
7. Assumptions are labelled **Assumption** and carry an owner and a resolve-by date.
8. Anything not yet true is written in future tense and marked **Planned**. Do not describe intent as if it were implemented.

---

## 9. Reality disclaimer

Fern Bank is a fictional institution. This package is an illustrative, exercise-grade architecture and governance submission created for training, review practice and demonstration.

The regulatory analysis references real instruments published by APRA and the RBNZ and reflects their intent as understood at the date of writing. It is **not** legal or regulatory advice. Before any real-world use, every citation must be verified against the current published instrument, and the position must be reviewed by qualified legal, risk and compliance professionals in each jurisdiction.

Cloud service capabilities evolve. Service names, quotas, regional availability and feature support must be confirmed against current vendor documentation at the time of build.
