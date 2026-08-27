# Control Matrix

**Document ID:** FB-KORU-401
**Version:** 1.0
**Date:** 27 August 2026
**Owner:** Head of Regulatory Compliance and Model Risk
**Status:** Submitted for Architecture Review Board review
**Related documents:** [Regulatory landscape](regulatory-landscape.md) (FB-KORU-400), [CPS 230](apra/cps-230-operational-risk.md) (FB-KORU-410), [CPS 234](apra/cps-234-information-security.md) (FB-KORU-411), [CPG 235](apra/cpg-235-data-risk.md) (FB-KORU-412), [BS11](rbnz/bs11-outsourcing.md) (FB-KORU-420), [Cyber resilience](rbnz/cyber-resilience.md) (FB-KORU-421), [Model risk management](ai-governance/model-risk-management.md) (FB-KORU-430), [Responsible AI assessment](ai-governance/responsible-ai-assessment.md) (FB-KORU-431), [Privacy impact assessment](privacy/privacy-impact-assessment.md) (FB-KORU-440), [RAID log](../06-delivery/raid-log.md) (FB-KORU-602)

---

## 1. Purpose

This is the master traceability artefact for Project Koru. Every control claim made anywhere in the submission carries a control ID, and every one of those IDs resolves here. The matrix answers three questions a regulator, an auditor or a Board member will ask:

1. What controls exist, who owns them, and where do they live in the architecture.
2. Which regulatory obligation does each control satisfy, so that no obligation is left uncovered.
3. How do we test each control, how often, and what evidence does the test produce.

Per drafting rule 4 in the [programme canon](../programme-canon.md#8-drafting-conventions), every control claim in the pack must trace to a row in this document. If a control is cited elsewhere and does not appear here, that is a defect in the pack, not a control that exists.

> **Caveat.** Fern Bank is a fictional institution and this is exercise-grade material for architecture review practice, not legal advice. Control statuses, owners and evidence are constructed for the exercise. Every regulatory mapping must be verified against the current published instrument and reviewed by qualified legal, risk and compliance counsel before real-world reliance.

---

## 2. How to read this matrix

### 2.1 Control identifier ranges

Control IDs follow the ranges fixed in the [programme canon](../programme-canon.md#6-document-identifiers).

| Range | Domain | Controls |
|---|---|---|
| C-01 to C-09 | Governance and oversight | C-01 to C-08 |
| C-10 to C-19 | Identity and access | C-10 to C-18 |
| C-20 to C-29 | Data protection and privacy | C-20 to C-28 |
| C-30 to C-39 | AI safety and model risk | C-30 to C-39 |
| C-40 to C-49 | Operational resilience | C-40 to C-48 |
| C-50 to C-59 | Third party and outsourcing | C-50 to C-58 |
| C-60 to C-69 | Monitoring, logging and evidence | C-60 to C-68 |
| C-70 to C-79 | Conduct and customer outcomes | C-70 to C-79 |

Seventy-three controls are defined. The register is deliberately not fully saturated in every range, so that new controls can be added at their natural place as the programme matures without renumbering.

### 2.2 Control type

| Type | Meaning |
|---|---|
| Preventive | Stops an undesirable event from occurring. |
| Detective | Identifies that an undesirable event has occurred or is occurring. |
| Corrective | Restores a correct state after an undesirable event. |
| Directive | Sets the expectation or accountability that governs behaviour. |

Many controls are a blend. The register records the dominant type, and notes secondary behaviour in the description.

### 2.3 Automation

**Automated** controls execute without a human in the loop and produce machine evidence. **Manual** controls depend on a person performing an activity and producing an artefact. **Hybrid** controls combine both. Automated controls are preferred wherever the risk allows, because "we can demonstrate the control was applied to every interaction" is worth more to a supervisor than an attestation that it usually is.

### 2.4 Status

| Status | Meaning |
|---|---|
| **Met** | Designed, implemented and evidenced for Phase 0 and Phase 1. |
| **Partially met** | Designed and partly implemented. Residual work is scheduled. See gaps in section 12. |
| **Planned** | Designed, not yet implemented. Scheduled before the relevant gate. |
| **Not applicable** | Out of scope for Phase 1, recorded for completeness and later phases. |

An honest matrix is mostly amber at this stage of a programme. A control register in which every row is green before a single customer has spoken to the system is not credible, and a Board should distrust one that claims it.

---

## 3. Register: governance and oversight (C-01 to C-08)

| ID | Control | Description | Type | Automation | Owner | Implementing component | Status |
|---|---|---|---|---|---|---|---|
| C-01 | Board and committee oversight | Koru risk reporting flows through the Technology and Operational Risk Committee to the Board Risk Committee, with a monthly assurance report per ARB condition C8. | Directive | Manual | Chief Risk Officer | Governance forum | Partially met |
| C-02 | AI management system | Documented AI management system aligned to ISO/IEC 42001, with policy, objectives, roles and lifecycle controls. | Preventive | Manual | Head of AI Governance | AI governance framework | Partially met |
| C-03 | Model risk policy and committee | Model Risk Committee with mandate over tiering, validation and monitoring. Model risk policy applies to every model in Koru. | Directive | Manual | Head of Model Risk | Governance forum | Met |
| C-04 | Phase gate approval | Each delivery phase is a separate ARB gate with explicit conditions. Approval of one phase does not imply the next. | Preventive | Manual | Chief Architect | Architecture Review Board | Met |
| C-05 | Three lines of defence | Defined first, second and third line responsibilities for Koru and its models, with independence of validation and audit. | Directive | Manual | Chief Risk Officer | Operating model | Partially met |
| C-06 | Risk appetite and key risk indicators | Koru risk appetite statement with KRIs for groundedness, unsafe response rate, escalation rate and complaint rate, monitored against thresholds. | Detective | Hybrid | Chief Risk Officer | Risk dashboard | Partially met |
| C-07 | Policy framework | Operational risk, information security, data, AI, privacy and conduct policies are extended to and applied to Koru. | Preventive | Manual | Head of Compliance | Policy register | Met |
| C-08 | Accountability and role mapping | Named accountable executives for every regulatory relationship, and documented Board accountability for information security under CPS 234. | Directive | Manual | Company Secretary | Accountability statements | Met |

---

## 4. Register: identity and access (C-10 to C-18)

| ID | Control | Description | Type | Automation | Owner | Implementing component | Status |
|---|---|---|---|---|---|---|---|
| C-10 | Customer authentication | Customers authenticate through Fern ID using passkeys and multi-factor authentication. Koru never authenticates a customer independently. | Preventive | Automated | Head of Identity | Fern ID | Met |
| C-11 | Step-up authentication and signed intent | Sensitive actions require a step-up challenge. Phase 3 value movement will require cryptographically signed intent. | Preventive | Automated | Head of Identity | Fern ID | Partially met |
| C-12 | Entitlement authorisation | Every action Koru attempts is authorised by Fern Entitlements on a deny-by-default basis. | Preventive | Automated | Head of Identity | Fern Entitlements | Met |
| C-13 | Voice is never an authentication factor | No voiceprint is enrolled or stored. Voice is treated as untrusted input throughout, per ADR-0004. | Preventive | Automated | Head of Fraud | Orchestrator, Assurance Plane | Met |
| C-14 | Privileged access management | Just-in-time privileged access for platform operators, with approval workflow and time-bound elevation. | Preventive | Automated | Chief Information Security Officer | Entra PIM | Partially met |
| C-15 | Workload identity isolation | Managed identities per jurisdiction with no shared credentials, so a workload in one jurisdiction holds no access in the other, per ADR-0003. | Preventive | Automated | Head of Infrastructure | Entra, Terraform | Met |
| C-16 | Read-only enforcement | Phase 1 exposes no write paths. Write prevention is enforced at the entitlement, API and network layers, per ADR-0005. | Preventive | Automated | Chief Architect | Fern Entitlements, integration, network | Met |
| C-17 | Secrets and key management | Secrets and keys held in HSM-backed Key Vault with rotation. No secrets in source or configuration. | Preventive | Automated | Chief Information Security Officer | Azure Key Vault | Met |
| C-18 | Session and token management | WebRTC sessions are bound and time-limited, with token expiry and re-authentication on entry to a sensitive context. | Preventive | Automated | Head of Platform Engineering | Koru Orchestrator | Partially met |

---

## 5. Register: data protection and privacy (C-20 to C-28)

| ID | Control | Description | Type | Automation | Owner | Implementing component | Status |
|---|---|---|---|---|---|---|---|
| C-20 | Data classification | Every Koru information asset is classified by criticality and sensitivity, including assets managed by third parties. | Preventive | Hybrid | Head of Data | Data catalogue | Met |
| C-21 | Encryption at rest and in transit | Customer-managed keys at rest and TLS 1.2 or higher in transit, with separate keys per jurisdiction. | Preventive | Automated | Chief Information Security Officer | Platform-wide | Met |
| C-22 | Data residency enforcement | Azure Policy allowed-locations initiative denies resource creation outside the permitted region per jurisdiction, per ADR-0003. | Preventive | Automated | Head of Infrastructure | Azure Policy, Terraform | Met |
| C-23 | PII detection and minimisation | Inbound personal information is detected and minimised in prompts, and redacted before logging where not required. | Preventive | Automated | Chief Privacy Officer | Assurance Plane | Partially met |
| C-24 | Telemetry content stripping | Only aggregated, non-re-identifiable metrics cross jurisdiction. Content and identifiers are stripped before export, verified in CI, per ADR-0003. | Preventive | Automated | Chief Privacy Officer | Telemetry pipeline | Met |
| C-25 | Retention and disposal | The Ledger is retained 7 years. Audio and transcripts follow a defined retention schedule with automated disposal. | Preventive | Automated | Head of Data | Koru Ledger, data platform | Partially met |
| C-26 | Privacy by design and PIA | A privacy impact assessment is maintained, with change triggers that require reassessment before material change. | Preventive | Manual | Chief Privacy Officer | Privacy programme | Met |
| C-27 | Corpus provenance and validity | Corpus entries carry an owner, a version and a validity window. Expired content is not retrievable. | Preventive | Automated | Head of Product Content | Koru Knowledge Plane | Met |
| C-28 | Access and correction handling | Customer access and correction requests are handled through a defined workflow, supported by Ledger retrieval. | Corrective | Manual | Chief Privacy Officer | Privacy programme, Ledger | Partially met |

---

## 6. Register: AI safety and model risk (C-30 to C-39)

| ID | Control | Description | Type | Automation | Owner | Implementing component | Status |
|---|---|---|---|---|---|---|---|
| C-30 | Assurance Plane fail-closed enforcement | Every inbound and outbound turn crosses the separately deployed policy service, which fails closed, per ADR-0006. This is the single enforceable choke point. | Preventive | Automated | Head of AI Engineering | Koru Assurance Plane | Met |
| C-31 | Intent and scope classification | Inbound classification of intent, scope and jurisdiction. Out-of-scope requests are refused before reaching the model. | Preventive | Automated | Head of AI Engineering | Koru Assurance Plane | Partially met |
| C-32 | Groundedness scoring | Outbound responses are scored for groundedness. Below the 0.95 threshold, Koru refuses rather than answers. | Detective | Automated | Head of Model Risk | Koru Assurance Plane | Partially met |
| C-33 | Mandatory AI disclosure | Koru discloses that it is not human at session start, on request, and at every handoff, per ADR-0012. | Preventive | Automated | Head of Customer Experience | Conversation design, Orchestrator | Met |
| C-34 | Citation binding and numeric verification | Substantive answers are bound to a retrieved, approved source, and numeric values are verified against source, per ADR-0007. | Preventive | Automated | Head of Model Risk | Koru Knowledge Plane, Assurance Plane | Partially met |
| C-35 | Corpus currency refusal | Retrieval on an empty or stale corpus fails closed. Koru refuses rather than quoting withdrawn content. | Preventive | Automated | Head of AI Engineering | Koru Knowledge Plane | Met |
| C-36 | Indirect injection defence | Retrieved content is treated as untrusted. Content provenance and indirect prompt injection defences apply, per the threat model. | Preventive | Automated | Chief Information Security Officer | Koru Knowledge Plane, Assurance Plane | Partially met |
| C-37 | Tool allow-listing | The Reasoning Plane may call only allow-listed, read-only tools. There is no arbitrary egress from the Reasoning Plane. | Preventive | Automated | Head of AI Engineering | Koru Reasoning Plane | Met |
| C-38 | Evaluation harness | Offline regression suites, golden datasets, red team suites, tone and disclosure checks, gating releases per ARB conditions C1 and C2. | Detective | Automated | Head of Model Risk | Evaluation harness | Partially met |
| C-39 | Drift detection and online sampling | Production drift baselines with online sampling and human review of a sampled stream of interactions. | Detective | Hybrid | Head of Model Risk | Observability platform | Planned |

---

## 7. Register: operational resilience (C-40 to C-48)

| ID | Control | Description | Type | Automation | Owner | Implementing component | Status |
|---|---|---|---|---|---|---|---|
| C-40 | Critical operations register and tolerances | Koru is mapped against the critical operations register and assessed as supporting, not constituting, a critical operation. Tolerance levels are defined. | Preventive | Manual | Head of Operational Risk | Operational risk framework | Met |
| C-41 | Business continuity plan | A Board-approved business continuity plan covers Koru, including degradation and recovery, and is regularly tested. | Preventive | Manual | Head of Operational Resilience | Continuity programme | Partially met |
| C-42 | Degradation ladder and non-generative fallback | A tested descent to a degraded, non-generative service keeps basic banking answers flowing if the AI platform is unavailable, per ARB condition C3. | Corrective | Hybrid | Head of Platform Engineering | Koru Orchestrator, fallback service | Partially met |
| C-43 | Availability SLOs and error budgets | Koru availability SLO of 99.5 percent and Fern Core of 99.95 percent, with an error budget policy governing change. | Detective | Automated | Head of Platform Engineering | Observability platform | Met |
| C-44 | Backup and recovery | Ledger recovery point objective of 15 minutes and Koru recovery time objective of 4 hours, with regular restore testing. | Corrective | Automated | Head of Infrastructure | Data platform, Ledger | Partially met |
| C-45 | Capacity management | Capacity model for AI, speech and search, including the New Zealand North capacity dependency tracked as KORU-R-10. | Preventive | Hybrid | Head of Infrastructure | Platform | Partially met |
| C-46 | Scenario and resilience testing | A scenario library including cyber compromise, provider impairment and region loss, exercised on a schedule. | Detective | Manual | Head of Operational Resilience | Continuity programme | Planned |
| C-47 | Change and release management | Controlled release with rollback, and model change control that returns family changes to ARB per condition C9. | Preventive | Hybrid | Head of Platform Engineering | DevOps pipeline | Met |
| C-48 | Zone-redundant deployment | Availability zones within jurisdiction, with no cross-Tasman failover, per ADR-0003. | Preventive | Automated | Head of Infrastructure | Azure, Terraform | Met |

---

## 8. Register: third party and outsourcing (C-50 to C-58)

| ID | Control | Description | Type | Automation | Owner | Implementing component | Status |
|---|---|---|---|---|---|---|---|
| C-50 | Material service provider register and compendium | Microsoft Azure is registered as a material service provider under CPS 230 and recorded in the BS11 compendium. | Preventive | Manual | Head of Outsourcing | Outsourcing register | Partially met |
| C-51 | Third party due diligence | Due diligence is performed before entering into or materially changing a material service arrangement. | Preventive | Manual | Head of Procurement | Procurement process | Met |
| C-52 | Contract minimum content | The Azure agreement is uplifted to CPS 230 minimum content, including business continuity and step-in rights, and BS11 prescribed terms. | Preventive | Manual | General Counsel | Contract | Partially met |
| C-53 | Fourth party and subcontractor management | Fourth party supply chain risk, including subprocessors, is identified and managed. | Detective | Manual | Head of Outsourcing | Subprocessor register | Partially met |
| C-54 | Ongoing service provider monitoring | Performance, service level and risk monitoring of Azure against agreed measures. | Detective | Hybrid | Head of Outsourcing | Vendor management | Partially met |
| C-55 | Separation plan | The BS11 separation plan is extended to cover Koru and is tested annually. | Corrective | Manual | Head of Outsourcing | Separation plan | Planned |
| C-56 | Offshoring assessment and notification | Material offshoring is assessed and notified. Jurisdictional isolation limits offshoring exposure to non-customer data. | Preventive | Manual | Head of Regulatory Compliance | Compliance process | Met |
| C-57 | Third party assurance | SOC 2, ISO 27001 and bridge letters are obtained and reviewed for the provider and material subprocessors. | Detective | Manual | Chief Information Security Officer | Assurance register | Partially met |
| C-58 | Concentration and exit management | Concentration risk is monitored as KORU-R-03, with a portability layer and tested non-generative fallback, per ADR-0009. | Corrective | Manual | Chief Technology Officer | Exit plan | Partially met |

---

## 9. Register: monitoring, logging and evidence (C-60 to C-68)

| ID | Control | Description | Type | Automation | Owner | Implementing component | Status |
|---|---|---|---|---|---|---|---|
| C-60 | Koru Ledger | Every prompt, retrieval, tool call, model version and guardrail decision is recorded immutably in a WORM, replayable Ledger retained 7 years, per ADR-0013. | Detective | Automated | Head of Data | Koru Ledger | Met |
| C-61 | Centralised security logging | Security events flow to a per-jurisdiction SIEM for correlation and alerting. | Detective | Automated | Chief Information Security Officer | Microsoft Sentinel | Partially met |
| C-62 | Replay for dispute and regulator evidence | The Ledger can be replayed to answer complaints, disputes and regulator requests with evidence rather than recollection. | Corrective | Hybrid | Head of Data | Koru Ledger | Met |
| C-63 | Assurance reporting | A monthly Koru assurance report to committee covers groundedness, refusal, escalation, complaint and vulnerability metrics, per ARB condition C8. | Detective | Manual | Head of Model Risk | Governance forum | Partially met |
| C-64 | Control testing programme | Systematic, risk-based testing of control effectiveness with documented results, per CPS 234. | Detective | Hybrid | Head of Operational Risk | Assurance programme | Partially met |
| C-65 | Internal audit review | Independent third line review of Koru and of critical outsourced arrangements. | Detective | Manual | Chief Audit Executive | Internal Audit | Planned |
| C-66 | Threat detection and response | Threat detections including AI-specific patterns, monitored by the security operations centre. | Detective | Automated | Chief Information Security Officer | Defender, Sentinel | Partially met |
| C-67 | Vulnerability and patch management | Scanning, patching and dependency management across the Koru stack against defined service levels. | Preventive | Automated | Chief Information Security Officer | DevSecOps pipeline | Partially met |
| C-68 | Evidence integrity and audit trail | Control evidence is held in a tamper-evident store with chain of custody, so evidence itself can be trusted. | Preventive | Automated | Head of Operational Risk | Evidence store | Partially met |

---

## 10. Register: conduct and customer outcomes (C-70 to C-79)

| ID | Control | Description | Type | Automation | Owner | Implementing component | Status |
|---|---|---|---|---|---|---|---|
| C-70 | Vulnerable customer detection | Distress and vulnerability signals are detected and trigger the vulnerability protocol, including a proactive human offer. | Detective | Automated | Head of Customer Experience | Koru Assurance Plane | Partially met |
| C-71 | Human handoff always available | The Kaitiaki Desk is reachable at any point in any session, per ADR-0014. Human contact never depends on Koru succeeding. | Preventive | Hybrid | Head of Contact Centre | Kaitiaki Desk, Orchestrator | Met |
| C-72 | No-pressure conversation design | Conversation design avoids dark patterns and pressure, and always offers an easy exit. | Preventive | Manual | Head of Customer Experience | Conversation design | Met |
| C-73 | Accent and speech-difference testing | Speech performance is tested by cohort, with an automatic text fallback offer on repeated low confidence. | Detective | Hybrid | Head of Customer Experience | Speech pipeline, evaluation | Planned |
| C-74 | Kaitiaki specialist training and review | Kaitiaki specialists are trained, and 100 percent of vulnerability protocol invocations are reviewed. | Detective | Manual | Head of Contact Centre | Kaitiaki Desk | Partially met |
| C-75 | Advice boundary classifier, inbound | An inbound classifier detects advice-seeking and is deliberately over-sensitive. It refuses or reframes rather than advising, per ADR-0011. | Preventive | Automated | Head of Model Risk | Koru Assurance Plane | Partially met |
| C-76 | Advice boundary enforcement, outbound | An outbound check prevents advice-like statements from reaching the customer, with the distress protocol taking precedence. | Preventive | Automated | Head of Model Risk | Koru Assurance Plane | Partially met |
| C-77 | Te Ao Māori cultural governance | Cultural advisory engagement, a cultural advisor veto on visual identity, and a gating condition on brand launch. | Preventive | Manual | Head of Customer Experience | Cultural governance | Planned |
| C-78 | Complaint detection and IDR routing | Complaint language is detected, logged to the Ledger, and routed into internal dispute resolution within ASIC RG 271 definitions and timeframes. | Detective | Hybrid | Head of Conduct Risk | Assurance Plane, IDR workflow | Partially met |
| C-79 | Fair conduct programme alignment | Koru behaviour is mapped to the CoFI fair conduct programme, with customer outcome monitoring. | Detective | Manual | Head of Conduct Risk | Conduct programme | Partially met |

---

## 11. Obligations, evidence and testing

This consolidated table completes each control row with the obligations it satisfies, the evidence artefact it produces, the test method and the test frequency. Obligation shorthand: CPS 230, CPS 234, CPG 235 are the APRA instruments; BS11 and Cyber are the RBNZ instruments; PA20 is the NZ Privacy Act and PA88 is the Australian Privacy Act; CoFI and RG 271 are conduct; ISO is ISO/IEC 42001; NIST is the AI RMF.

| ID | Obligations satisfied | Evidence artefact | Test method | Frequency |
|---|---|---|---|---|
| C-01 | CPS 230, CPS 234, BS11, Cyber, ISO | Committee papers and minutes | Governance review | Monthly |
| C-02 | ISO, NIST, CPG 235 | AI management system manual, ISO gap assessment | Internal audit | Annual |
| C-03 | CPG 235, ISO, model governance | Model risk policy, committee minutes | Policy attestation | Annual |
| C-04 | CPS 230, ISO | ARB submissions and decisions | Gate review | Per phase |
| C-05 | CPS 230, CPS 234 | Three lines of defence operating model | Assurance mapping review | Annual |
| C-06 | CPS 230 | Risk appetite statement, KRI dashboard | Threshold breach review | Monthly |
| C-07 | All standards | Policy register | Policy currency review | Annual |
| C-08 | CPS 234, CPS 230 | Accountability statements | Attestation | Annual |
| C-10 | CPS 234, PA20, PA88 | Authentication configuration, identity logs | Access test and penetration test | Continuous and annual |
| C-11 | CPS 234, conduct | Step-up policy, challenge logs | Control test | Quarterly |
| C-12 | CPS 234, consumer data boundary | Entitlement policies, decision logs | Authorisation test | Continuous |
| C-13 | CPS 234, fraud, PA20, PA88 | ADR-0004, architecture attestation | Design review and red team | Per release |
| C-14 | CPS 234 | Privileged access configuration, access logs | Access review | Quarterly |
| C-15 | CPS 234, BS11, PA20, PA88 | Terraform, identity registrations | CI policy check | Per deploy |
| C-16 | CPS 230, CPS 234, conduct | Architecture, write-attempt test results | Write-attempt test | Per release |
| C-17 | CPS 234, privacy security | Key Vault configuration, rotation logs | Secret scan and rotation test | Continuous |
| C-18 | CPS 234 | Session configuration | Session security test | Per release |
| C-20 | CPS 234, CPG 235, privacy | Asset register (FB-KORU-411) | Classification review | Quarterly |
| C-21 | CPS 234, PA20, PA88 | Encryption configuration | Configuration scan | Continuous |
| C-22 | BS11, PA20, PA88, CPS 230 | Azure Policy, Terraform | Policy compliance scan | Continuous |
| C-23 | PA20, PA88, CPG 235 | PII detection configuration, sample audits | Detection accuracy test | Monthly |
| C-24 | PA20, PA88, BS11 | Pipeline configuration, CI test | Re-identification test | Per deploy |
| C-25 | PA20, PA88, AML, CPS 234 | Retention schedule, disposal logs | Retention audit | Quarterly |
| C-26 | PA20, PA88 | Privacy impact assessment, change log | PIA review | Per material change |
| C-27 | CPG 235, conduct, CPS 234 | Corpus metadata, corpus health dashboard | Currency check | Continuous and monthly attestation |
| C-28 | PA20, PA88 | Request register, service level report | Request handling test | Quarterly |
| C-30 | CPS 234, conduct, ISO, NIST | Assurance Plane logs, fail-closed test | Fault injection | Per release |
| C-31 | conduct, advice boundary | Classifier configuration, evaluation | Classifier evaluation | Per release |
| C-32 | conduct, CPG 235 | Evaluation reports, production metric | Groundedness evaluation | Continuous |
| C-33 | conduct, transparency, ISO | Conversation design, session logs | Disclosure presence test | Per release |
| C-34 | conduct, fair dealing | Citation logs, evaluation | Citation and numeric evaluation | Continuous |
| C-35 | conduct, CPG 235 | Retrieval logs | Stale content test | Per release |
| C-36 | CPS 234, threat model | Threat model, red team report | Injection red team | Quarterly |
| C-37 | CPS 234, CPS 230 | Tool registry, configuration | Tool scope test | Per release |
| C-38 | ISO, NIST, model governance | Evaluation reports | Regression suite | Per change and continuous |
| C-39 | CPG 235, ISO, NIST | Drift dashboards, review logs | Drift alarm test | Continuous |
| C-40 | CPS 230 | Critical operations register, tolerance table | Tolerance review | Annual |
| C-41 | CPS 230, BS11 | Business continuity plan (FB-KORU-503) | Continuity exercise | Annual |
| C-42 | CPS 230, BS11 | Continuity test evidence | Full AI loss exercise | Annual |
| C-43 | CPS 230 | SLO dashboards (FB-KORU-500) | SLO reporting | Continuous |
| C-44 | CPS 230, BS11, CPS 234 | Backup configuration, restore test report | Restore test | Quarterly |
| C-45 | CPS 230 | Capacity plan | Load test | Per release |
| C-46 | CPS 230, Cyber | Scenario test reports | Tabletop and live exercise | Semi-annual |
| C-47 | CPS 230, CPS 234 | Change records | Change audit | Per change |
| C-48 | CPS 230, BS11, residency | Terraform, topology diagram | Zone failover test | Semi-annual |
| C-50 | CPS 230, BS11 | MSP register, compendium entry (FB-KORU-420) | Register review | Quarterly |
| C-51 | CPS 230, BS11 | Due diligence reports | Due diligence file review | Per arrangement |
| C-52 | CPS 230, BS11 | Contract, clause-to-requirement map | Contract compliance review | Per renewal |
| C-53 | CPS 230, CPS 234 | Subprocessor register | Supply chain review | Semi-annual |
| C-54 | CPS 230, BS11 | Vendor scorecards | Monitoring review | Quarterly |
| C-55 | BS11 | Separation plan, test report | Separation test | Annual |
| C-56 | CPS 230, BS11 | Offshoring assessment | Assessment review | Per arrangement |
| C-57 | CPS 234, CPS 230 | Assurance reports register | Assurance review | Annual |
| C-58 | CPS 230, BS11 | Exit plan, Board acceptance record | Exit rehearsal | Annual |
| C-60 | CPS 234, AML, conduct, privacy | Ledger, replay demonstration | Immutability and replay test | Per release and continuous |
| C-61 | CPS 234, Cyber | SIEM configuration, log coverage report | Log coverage test | Continuous |
| C-62 | RG 271, conduct, privacy access | Replay procedure | Replay drill | Semi-annual |
| C-63 | CPS 230, ISO | Committee papers | Report completeness review | Monthly |
| C-64 | CPS 234, CPS 230 | Control test plan and results | Test execution | Risk-based |
| C-65 | CPS 234, CPS 230 | Internal audit reports | Audit | Annual |
| C-66 | CPS 234, Cyber | Detection rules, SOC runbooks | Purple team exercise | Continuous |
| C-67 | CPS 234, CIRMP | Scan reports, patch service levels | Vulnerability scan | Continuous |
| C-68 | CPS 234, conduct | Evidence store configuration | Integrity test | Semi-annual |
| C-70 | CoFI, conduct, ISO | Detection configuration, protocol | Signal detection evaluation | Monthly |
| C-71 | CoFI, conduct, BS11 | Handoff design, availability SLO | Handoff test | Per release |
| C-72 | CoFI | Conversation design, design review | Design review | Per release |
| C-73 | CoFI, accessibility, fairness | Cohort test results (FB-KORU-103) | Cohort evaluation | Per release |
| C-74 | CoFI, conduct | Training records, review logs | Review audit | Ongoing |
| C-75 | advice regimes, CoFI | Classifier evaluation (ADR-0011) | Boundary evaluation | Per release |
| C-76 | advice regimes, CoFI | Outbound policy, evaluation | Outbound evaluation | Per release |
| C-77 | Algorithm Charter, conduct | Engagement record (FB-KORU-103) | Advisory sign-off | Per milestone |
| C-78 | RG 271, CoFI | Complaint logs, IDR handoff record | Complaint routing test | Monthly |
| C-79 | CoFI | Fair conduct programme mapping, outcome metrics | Conduct review | Quarterly |

---

## 12. Reverse lookup: obligation to control

These tables let a reviewer start from a regulatory obligation and confirm it is covered. They are the mirror image of section 11.

### 12.1 APRA CPS 230 Operational Risk Management

| CPS 230 requirement | Controls |
|---|---|
| Operational risk management framework | C-01, C-05, C-06, C-07, C-40 |
| Critical operations and tolerance levels | C-40, C-43 |
| Business continuity, Board-approved and tested | C-41, C-42, C-46 |
| Service provider management policy | C-07, C-50, C-51, C-54 |
| Register of material service providers | C-50 |
| Due diligence and formal agreements with minimum content | C-51, C-52 |
| Step-in rights and business continuity in agreements | C-52 |
| Fourth party supply chain risk | C-53 |
| Ongoing monitoring | C-54, C-63, C-64 |
| Internal audit of critical outsourced arrangements | C-65 |
| 24 hour incident notification | C-48 supporting, C-66, C-61, and the incident process in FB-KORU-410 |
| Notification of material arrangements and offshoring | C-50, C-56 |

### 12.2 APRA CPS 234 Information Security

| CPS 234 requirement | Controls |
|---|---|
| Roles and responsibilities, Board accountability | C-01, C-08 |
| Information security capability | C-14, C-17, C-21, C-61, C-66, C-67 |
| Classification of information assets, including third party | C-20, C-27, C-53 |
| Implementation of controls | C-10 to C-18, C-21 to C-24, C-30 to C-37 |
| Systematic testing of control effectiveness | C-38, C-64, C-66 |
| Internal audit review | C-65 |
| Incident response | C-30, C-60, C-61, C-66, and FB-KORU-411 |
| 72 hour incident and 10 business day weakness notification | Incident process in FB-KORU-411, supported by C-61, C-63, C-68 |

### 12.3 RBNZ BS11 Outsourcing

| BS11 requirement | Controls |
|---|---|
| Continuity of basic banking services | C-16, C-40, C-42, C-71 |
| Compendium of outsourcing arrangements | C-50 |
| Separation plan, tested annually | C-55 |
| Prescribed contractual terms | C-52 |
| Non-objection where required | C-50, C-56 |
| Systems and data for crisis management and resolution | C-44, C-60, C-62 |
| No offshore dependency for customer data | C-15, C-22, C-24, C-48 |

### 12.4 APRA CPG 235 Managing Data Risk

| CPG 235 theme | Controls |
|---|---|
| Data governance | C-02, C-20, C-26 |
| Data quality | C-27, C-32, C-34, C-35 |
| Data architecture and lifecycle | C-22, C-25, C-48, C-60 |
| Data risk in third party arrangements | C-24, C-53, C-57 |

### 12.5 Privacy, NZ IPPs and AU APPs

| Privacy obligation | Controls |
|---|---|
| Purpose, collection and notice (IPP1 to 4, APP1, 3, 5) | C-23, C-26, C-33 |
| Storage and security (IPP5, APP11) | C-17, C-21, C-24, C-60, C-67 |
| Access and correction (IPP6, 7, APP12, 13) | C-28, C-62 |
| Accuracy and use (IPP8, 10, APP6, 10) | C-27, C-32, C-34 |
| Retention (IPP9, APP11) | C-25 |
| Cross-border disclosure (IPP12, APP8) | C-15, C-22, C-24, C-48 |
| Breach notification | Process in FB-KORU-440, supported by C-60, C-61, C-66 |

### 12.6 Conduct and AI standards

| Obligation or standard | Controls |
|---|---|
| CoFI fair conduct programme | C-70, C-71, C-72, C-74, C-79 |
| ASIC RG 271 internal dispute resolution | C-62, C-78 |
| Advice boundary (advice regimes) | C-31, C-75, C-76 |
| Transparency and disclosure | C-33 |
| ISO/IEC 42001 AI management | C-02, C-03, C-38, C-39, C-63 |
| NIST AI RMF Govern, Map, Measure, Manage | C-02, C-06, C-30, C-38, C-39 |
| NZ Algorithm Charter | C-77 |

---

## 13. Coverage summary

### 13.1 Controls by domain and status

| Domain | Total | Met | Partially met | Planned | Not applicable |
|---|---:|---:|---:|---:|---:|
| Governance and oversight | 8 | 4 | 4 | 0 | 0 |
| Identity and access | 9 | 6 | 3 | 0 | 0 |
| Data protection and privacy | 9 | 5 | 4 | 0 | 0 |
| AI safety and model risk | 10 | 4 | 5 | 1 | 0 |
| Operational resilience | 9 | 4 | 4 | 1 | 0 |
| Third party and outsourcing | 9 | 2 | 6 | 1 | 0 |
| Monitoring, logging and evidence | 9 | 2 | 6 | 1 | 0 |
| Conduct and customer outcomes | 10 | 3 | 5 | 2 | 0 |
| **Total** | **73** | **30** | **37** | **7** | **0** |

### 13.2 Reading the numbers

Thirty controls are Met, thirty-seven are Partially met, and seven are Planned. That distribution is exactly what a Board should expect from a programme at Phase 0 exit design review. The Planned controls cluster in resilience testing, internal audit, drift detection, separation planning and cultural governance, which are the activities that can only be completed once the platform is built and once external parties are engaged. None of the Planned controls is required to be operational before Phase 0 exit, and each is scheduled ahead of the gate at which it is needed. The concentration of Partially met controls in third party and monitoring reflects the open Microsoft contract uplift (KORU-I-02) and the fact that logging and assurance mature with real traffic.

### 13.3 Controls by type

| Type | Count |
|---|---:|
| Preventive | 37 |
| Detective | 24 |
| Corrective | 6 |
| Directive | 6 |

The register is preventive-weighted, which is the correct posture for a customer-facing system where the cheapest failure to manage is the one that never happens.

---

## 14. Risk to control traceability

The top risks in the [ARB submission](../../ARB-SUBMISSION.md) and [RAID log](../06-delivery/raid-log.md) each resolve to a set of controls.

| Risk | Description | Primary controls |
|---|---|---|
| KORU-R-01 | Confidently incorrect answer on fees, rates or terms | C-30, C-32, C-34, C-35, C-38 |
| KORU-R-02 | Prompt injection causes policy bypass | C-16, C-30, C-31, C-36, C-37 |
| KORU-R-03 | Concentration on a single AI platform provider | C-42, C-50, C-52, C-58, and Board acceptance |
| KORU-R-04 | Vulnerable customer harmed by an efficient interaction | C-70, C-71, C-72, C-74 |
| KORU-R-05 | Deepfaked customer voice used to socially engineer | C-11, C-13 |
| KORU-R-06 | Customer believes Koru is human | C-33 |
| KORU-R-07 | Latency worse than the channel it replaces | C-43, C-45 |
| KORU-R-08 | Retrieval corpus decays and quotes withdrawn content | C-27, C-35 |

---

## 15. Gaps and remediation

| Gap | Controls affected | Impact | Owner | Target date | Status |
|---|---|---|---|---|---|
| Microsoft contract not yet uplifted to CPS 230 minimum content | C-52, C-50, C-58 | Blocks material service provider registration and compendium update (ARB C4) | Head of Procurement | 20 December 2026 | Partially met |
| Internal audit review of Koru not yet scoped | C-65 | Third line assurance not yet evidenced | Chief Audit Executive | Before Phase 1 entry | Planned |
| Drift detection baselines not yet established | C-39 | Production drift not yet measurable until baselines exist | Head of Model Risk | Phase 0 exit | Planned |
| Separation plan extension for Koru not yet tested | C-55 | BS11 annual test evidence outstanding | Head of Outsourcing | Before Phase 1 entry | Planned |
| Accent and speech cohort testing participants not recruited | C-73 | Fairness evidence weak, tracked as KORU-I-05 | Head of Customer Experience | 31 October 2026 | Planned |
| Te Ao Māori cultural sign-off not yet obtained | C-77 | Gating condition on brand launch | Head of Customer Experience | Before brand launch | Planned |
| PII detection accuracy not yet validated at production scale | C-23 | Privacy minimisation partly unproven | Chief Privacy Officer | Phase 0 exit | Partially met |
| Scenario and resilience test library not yet exercised end to end | C-46, C-42 | Continuity evidence for ARB C3 incomplete | Head of Operational Resilience | Phase 0 exit | Planned |

---

## 16. Reality disclaimer

Fern Bank is a fictional institution. This control matrix is illustrative, exercise-grade material for architecture review practice, training and demonstration. Control statuses, owners, evidence artefacts and test frequencies are constructed for the exercise. The obligation mappings reference real published instruments and reflect their intent as understood at the date of writing, and they are not legal or regulatory advice. Verify every mapping against the current instrument and obtain qualified professional review before any real-world reliance. See the [programme canon](../programme-canon.md#9-reality-disclaimer).
