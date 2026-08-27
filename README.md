# nzbank

Reference material for New Zealand and Australian financial services.

Everything here is **demonstration and training material**, built to be read, reviewed, pulled apart and reused.

---

## Read this first

If you work in Security, Cyber or Risk, these are the facts you need before you open anything.

| Question | Answer |
|---|---|
| Is any of this connected to a live system? | **No.** Nothing connects to a real bank, cloud tenant or network. |
| Does it contain real customer data? | **No.** Every name, balance, account and transaction is invented. |
| Does it contain credentials, keys or tokens? | **No.** No secrets are committed. The Terraform uses managed identity and Key Vault references only. |
| Is "Fern Bank" real? | **No.** A fictional bank used as a worked example throughout. |
| Has the Terraform been applied anywhere? | **No.** Treat it as a design artefact, not a deployment. |
| Is the regulatory analysis authoritative? | **No.** It cites real APRA and RBNZ instruments accurately, but it is not legal or regulatory advice. |

**Bottom line:** safe to read, share and fork. Not safe to deploy without review.

---

## What is in here

| Folder | What it is | Useful for |
|---|---|---|
| **[`avatar/`](avatar/)** | An Architecture Review Board submission for an AI banking avatar, with security, regulatory and infrastructure design | Security architecture review, AI risk, regulatory mapping |
| **[`website/`](website/)** | A working demo retail banking web app, built to be reviewed and extended | Secure code review practice, appsec training |
| **[`capabilities/`](capabilities/)** | Self contained agent skills | Automating parts of your own workflow |

---

## Start here: the avatar pack

[`avatar/`](avatar/) is the most useful thing in this repo for a security reader.

It is a full design and governance package for **Project Koru**, a hypothetical real-time conversational AI avatar for retail banking, written as if it were going to a bank's Architecture Review Board in New Zealand and Australia.

It was written to be genuinely reviewable rather than to look finished. It includes the risks that were not solved.

**Two entry points:**

- [ARB submission](avatar/ARB-SUBMISSION.md) if you want the argument
- [Diagram set](avatar/diagrams/) if you would rather see it than read it

### The security thinking lives in the decision records

The [14 decision records](avatar/docs/02-architecture/adr/) are the fastest way to understand the security posture. Six matter most.

| Decision | Position taken |
|---|---|
| [ADR-0004](avatar/docs/02-architecture/adr/ADR-0004-no-voice-biometric-authentication.md) | **Voice is never an authentication factor.** Voice cloning has made voiceprints an unrevocable, publicly harvestable credential |
| [ADR-0005](avatar/docs/02-architecture/adr/ADR-0005-read-only-first.md) | **Read-only first.** Write prevention at three independent layers, so a fully compromised model still cannot move money |
| [ADR-0006](avatar/docs/02-architecture/adr/ADR-0006-assurance-plane-as-a-service.md) | **Guardrails are a separate service, not a library**, so control application is provable per interaction instead of asserted by code review |
| [ADR-0007](avatar/docs/02-architecture/adr/ADR-0007-grounded-response-only.md) | **Grounded or silent.** Includes the measured evidence: an un-grounded model was materially wrong 25 percent of the time |
| [ADR-0008](avatar/docs/02-architecture/adr/ADR-0008-no-customer-data-in-training.md) | **Customer conversations are never training data.** Retrieval, not absorption |
| [ADR-0013](avatar/docs/02-architecture/adr/ADR-0013-immutable-interaction-ledger.md) | **Immutable, replayable interaction record**, and an honest account of the privacy cost of building one |

### Other security relevant documents

| Document | Why you would read it |
|---|---|
| [Security architecture](avatar/docs/03-security/security-architecture.md) | Zero trust position, defence in depth, key management, container and supply chain security, secure SDLC gates |
| [Control matrix](avatar/docs/04-compliance/control-matrix.md) | Controls mapped to APRA CPS 230, CPS 234, RBNZ BS11 and both Privacy Acts, with evidence artefacts and test methods |
| [Regulatory landscape](avatar/docs/04-compliance/regulatory-landscape.md) | Every instrument that applies across both jurisdictions and why |
| [AI architecture](avatar/docs/02-architecture/ai-architecture.md) | Model routing, grounding, tool calling allow-list, guardrail chain, prompt injection defence, evaluation |
| [Data architecture](avatar/docs/02-architecture/data-architecture.md) | Classification, residency, retention, the immutable ledger, PII handling, encryption |
| [RAID log](avatar/docs/06-delivery/raid-log.md) | The risk register, including the three risks deliberately left unresolved |
| [Terraform](avatar/terraform/) | Security controls as code: private endpoints, no public data plane, customer managed keys, Azure Policy |

### The honest bits

Three risks in that pack are deliberately unresolved, because a package where everything is green is not one anyone should trust.

- **Vendor concentration** on a single AI platform. Bounded, not solved. Escalated for formal acceptance.
- **The evaluation harness cannot detect failure classes nobody thought of.** Mitigated by keeping the phase read-only, so a novel failure misinforms rather than transacts.
- **Customers may substitute an always-available AI for human contact in ways that harm them.** Flagged with a weak treatment and an admission that it is weak.

### Status

This is an initial version. Some documents referenced inside the pack are still to be written.

| Area | Status |
|---|---|
| Programme, ARB submission, decision records, diagrams | **Drafted** |
| Architecture: solution, AI, data, integration, cloud services | **Drafted** |
| Security architecture | **Drafted** |
| Compliance: control matrix, regulatory landscape | **Drafted** |
| Delivery: roadmap, cost model, RAID log | **Drafted** |
| Executive summary | **Drafted** |
| Terraform: network, security, AI platform, knowledge, observability modules | **Drafted** |
| Threat model, identity and authentication | **To do** |
| APRA, RBNZ, privacy and AI governance assessments | **To do** |
| Experience and customer journey | **To do** |
| Operations: service levels, incident response, continuity, runbook | **To do** |
| Terraform: remaining modules and environment compositions | **To do** |

---

## The demo banking app

[`website/`](website/) is a small retail banking front end. Vanilla HTML, CSS and JavaScript. No framework, no build step, no backend.

```powershell
cd website
python -m http.server 8000
```

It exists to be **reviewed and extended**. [`website/EXERCISE.md`](website/EXERCISE.md) has a structured brief with a review task, three extension tracks and a marking rubric.

For an appsec reviewer it is a reasonable frontend code review target. Be clear about what it is: client-side only, no server, no authentication, no data layer. Every validation in it is user experience, not security. That is stated in the code and the docs, and noticing the implications is part of the exercise.

---

## Capabilities

Self contained agent skills. Each folder has a `SKILL.md` describing what it does and when it triggers.

| Capability | What it does |
|---|---|
| [`ai-prompt-engineering-safety-review`](capabilities/ai-prompt-engineering-safety-review/) | Reviews a prompt for safety, bias and security weaknesses, and suggests improvements |
| [`code-to-mermaid`](capabilities/code-to-mermaid/) | Scans a source folder and produces an architecture diagram with module dependencies |
| [`aws-cost-optimize`](capabilities/aws-cost-optimize/) | Analyses AWS infrastructure as code and resources, and raises cost optimisation issues |
| [`eyeball`](capabilities/eyeball/) | Analyses a document and produces a report where every claim carries a screenshot of its source |

`ai-prompt-engineering-safety-review` is the one most likely to earn its place in a security workflow.

---

## Using this safely

Most of the risk here is misuse, not content.

1. **Do not apply the Terraform to a real subscription** without a full review. It is written to be correct and readable, and it has never been run.
2. **Do not lift the regulatory analysis into a real submission.** Verify every citation against the current instrument and have qualified counsel review it.
3. **Do not treat the demo app as a secure reference implementation.** It is deliberately a frontend-only prototype.
4. **Do not commit anything real here.** No customer data, no internal architecture, no credentials, no tenant identifiers.
5. **The numbers are invented.** Costs, latencies, error rates and volumes exist to make the exercise coherent. Do not benchmark against them.

---

## Conventions

If you add to this repo, match what is already here.

| Convention | Rule |
|---|---|
| Language | New Zealand English: organisation, realise, centre, programme, licence (noun) |
| Punctuation | **No em-dashes.** Use full stops, commas, "and", "to", or a colon |
| Diagrams | Mermaid inside Markdown. No binary image dependencies |
| Documents | Open with a metadata block: Document ID, Version, Date, Owner, Status |
| Honesty | Mark unbuilt things **Planned** and assumptions **Assumption** with an owner and a resolve-by date. Do not describe intent as if it were implemented |
| Secrets | Never. Managed identity and Key Vault references only |

---

## Licence and status

Educational and demonstration material, for learning, review practice, training and internal discussion.

Nothing here is legal, regulatory, security or financial advice.
