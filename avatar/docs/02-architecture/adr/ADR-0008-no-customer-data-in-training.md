# ADR-0008: Customer data is never used to train or fine-tune models

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 8 July 2026 |
| **Decision makers** | Chief Architect, Chief Privacy Officer, Head of Model Risk, General Counsel |
| **Contested** | No. |
| **Reversibility** | **Hard.** Would require fresh consent, fresh privacy assessments and regulator engagement in both jurisdictions. |
| **Related risks** | KORU-R-01, and a category of privacy risk not otherwise in the register |

---

## Context

Koru will generate an enormous, high-quality corpus of real customer conversations. Millions of turns of authentic language, real questions, real confusion, real emotion.

That corpus is, from a machine learning perspective, extraordinarily valuable. Fine-tuning on it would improve intent recognition, produce more natural responses, and teach the model Fern Bank's specific vocabulary and customer patterns. The temptation to use it will be persistent and will come from good people with good intentions.

There are three problems.

**One, it is not what the customer agreed to.** A customer asking about an overdraft fee is seeking help. They are not contributing to a training set. Consent obtained for service delivery does not extend to model training, and a consent notice broad enough to cover it would be a consent notice no reasonable person would give informed agreement to.

**Two, models memorise.** Training data can be extracted from a trained model. A model fine-tuned on real conversations may, under adversarial or even accidental prompting, reproduce fragments of another customer's situation. Once personal information is absorbed into model weights, it cannot be deleted on request. A right to erasure becomes technically unsatisfiable.

**Three, it creates a one way door with no exit.** A fine-tuned model containing customer data cannot be un-trained. If the position is later found to be wrong, the only remedy is to discard the model.

## Decision

**Customer conversations, transcripts, audio, prompts, completions, embeddings of customer utterances, and any derived customer data are never used to train, fine-tune, distil, align or otherwise adapt any model, whether operated by Fern Bank or by any third party.**

This is absolute and has no exception process. A future decision to change it requires a superseding ADR, fresh privacy impact assessments in both jurisdictions, a fresh consent basis, and Board approval.

### The specific commitments

| Commitment | Enforcement |
|---|---|
| No customer data leaves the platform for vendor model improvement | Contractual with Microsoft, plus the Azure OpenAI enterprise data handling position which excludes customer prompts and completions from model training. Verified at contract and re-verified annually |
| No Fern Bank fine-tuning on customer data | No fine-tuning pipeline exists that can read the Ledger or the transcript store. Enforced by identity: no training workload identity holds a read role on customer data stores. Control KORU-C-33 |
| No embeddings of customer utterances are retained beyond the session | Session vectors are ephemeral, held in Redis with a TTL, and are never written to the search index. Control KORU-C-22 |
| Evaluation datasets are synthetic or explicitly consented | See below |
| No customer voice audio is retained at all | Audio is transient. Only the transcript is written to the Ledger. Control KORU-C-21 |

### How we improve without customer data

This decision would be irresponsible if it left us unable to improve the system. It does not.

| Improvement need | How it is met without training on customer data |
|---|---|
| Better answers | Improve the **retrieval corpus**, which is Fern Bank's own product content, not customer data. This is where most quality gains actually come from |
| Better intent handling | Improve **prompts and routing configuration**, which are engineering artefacts |
| Better evaluation coverage | Build **synthetic conversations** informed by aggregate, de-identified failure patterns. We learn "customers frequently ask about fee reversals in a confused way" without retaining any individual's confused question |
| Fixing a specific failure | Analyse the individual interaction from the Ledger under controlled access for **incident and complaint handling**, which is a legitimate operational purpose, and then encode the fix in the corpus or the prompt, not in weights |
| Explicitly consented research | A separate, opt-in, revocable programme with its own consent, its own retention limit and its own governance. **Planned**, not in Phase 1, and even then it feeds evaluation, not training |

The key insight is that **retrieval-augmented systems improve through better retrieval, not better weights.** This decision costs us far less than it would have cost a pre-RAG architecture.

### The distinction that matters

There is an important line between *training* and *operating*, and we state it explicitly because it is easy to blur:

| Activity | Permitted? | Why |
|---|---|---|
| Sending a customer's question to the model to answer it | **Yes** | This is service delivery. The model processes it and does not retain it |
| Retrieving the customer's own account data into the prompt context | **Yes** | Service delivery, minimised, and never persisted in the model |
| Storing the transcript in the Ledger | **Yes** | Regulatory record keeping, 7 years, with a stated lawful basis |
| Reviewing a specific interaction after a complaint | **Yes** | Legitimate operational purpose, access controlled and logged |
| Aggregating de-identified failure patterns | **Yes** | No individual is identifiable, k-anonymity floor applied |
| Fine-tuning on transcripts | **No** | |
| Building a retrieval index of past customer conversations | **No** | This would make one customer's conversation retrievable into another's context |
| Sending transcripts to a vendor for model improvement | **No** | |

The sixth row deserves emphasis because it is a design people reach for. "Let Koru learn from previous conversations" sounds helpful and is in fact a data leakage architecture.

## Consequences

### Positive

- **The right to erasure remains satisfiable.** We can delete a customer's data because it exists only in stores we control, not in weights we cannot edit.
- **A clean, honest answer to the question customers now ask.** "Are you training AI on my conversations?" is answered "No", without qualification.
- **Removes an entire class of privacy risk**, including training data extraction, membership inference and cross-customer leakage.
- **Simplifies both privacy impact assessments substantially.**
- **Removes a bias amplification pathway.** A model fine-tuned on historical conversations would inherit whatever inequities exist in who historically got good service.

### Negative

- **We forgo genuine quality gains** that fine-tuning would deliver, particularly on domain-specific intent recognition.
- **Higher reliance on prompt engineering and retrieval quality**, which requires ongoing skilled effort.
- **Synthetic evaluation data is harder to build** and may not fully represent real customer language, especially for edge cases and distressed customers. This is a genuine limitation and it is recorded in the RAID log.
- **Competitors willing to train on customer data may achieve better intent handling.**

### Neutral

- No material cost difference. Fine-tuning cost saved roughly offsets the synthetic data generation cost.

## Alternatives considered

| Option | Assessment |
|---|---|
| **Fine-tune on de-identified transcripts** | Rejected. De-identification of free-form conversational text is unreliable. Customers volunteer identifying detail constantly ("since my husband died in March", "at the Riccarton branch"). Re-identification risk in a fine-tuned model is not adequately controlled by redaction. |
| **Opt-in training with clear consent** | Rejected for Phase 1, and probably permanently. Even with genuine consent, the irreversibility problem remains: a consenting customer who later withdraws consent cannot have their data removed from the weights. Consent that cannot be withdrawn effectively is not meaningful consent. |
| **Train only on Fern Bank staff pilot conversations** | **Accepted in principle for Phase 0.** Staff conversations against synthetic accounts, with informed staff consent and no customer data, are a legitimate source. Limited value, but it is genuinely permitted and is the one carve-out. |
| **Use conversations to build the retrieval corpus** | Rejected. Would make one customer's conversation retrievable into another customer's context. This is a data breach architecture with extra steps. |

## Compliance implications

| Obligation | Implication |
|---|---|
| Privacy Act 2020 (NZ), IPP 10 | Use is limited to the purpose of collection. Training is a materially different purpose and is excluded. |
| Privacy Act 2020 (NZ), IPP 9 | Retention is limited and deletion is genuinely achievable. |
| Privacy Act 1988 (AU), APP 6 | Same position for use and disclosure. |
| APRA CPG 235 | Data lifecycle and purpose limitation are clear and enforceable. |
| ISO/IEC 42001 | Supports the data governance and AI system lifecycle clauses. |
| Australia's AI Ethics Principles | Directly supports privacy protection and human-centred values. |

---

## Related documents

- [Privacy impact assessment](../../04-compliance/privacy/privacy-impact-assessment.md) (FB-KORU-440)
- [Data architecture](../data-architecture.md) (FB-KORU-203)
- [Model risk management](../../04-compliance/ai-governance/model-risk-management.md) (FB-KORU-430)
- [ADR-0013 Immutable interaction ledger](ADR-0013-immutable-interaction-ledger.md)
